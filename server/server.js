const fs = require('fs');

const express = require('express');
const cors = require('cors');
const mysql = require('mysql2/promise');
const path = require('path');
require('dotenv').config({ path: path.join(__dirname, '.env') });

const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

const pool = mysql.createPool({
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT || '3306', 10),
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'sofaliving_db',
  ssl: process.env.DB_SSL === 'true'
    ? { ca: fs.readFileSync(path.join(__dirname, 'certs', 'ca_sofaliving.pem')) }
    : undefined,
    decimalNumbers: true, 
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

// Helper for parsing JSON safely
const parseJsonField = (val) => {
  if (!val) return null;
  if (typeof val === 'object') return val;
  try {
    return JSON.parse(val);
  } catch (e) {
    return val;
  }
};

// Health Check
app.get('/api/health', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT 1 + 1 AS result');
    res.json({ status: 'ok', mysql: 'connected', timestamp: new Date().toISOString() });
  } catch (err) {
    res.status(500).json({ status: 'error', mysql: 'disconnected', error: err.message });
  }
});

// --- AUTHENTICATION ---
// Login
app.post('/api/auth/login', async (req, res) => {
  const { email, password } = req.body;
  if (!email || !password) {
    return res.status(400).json({ error: 'Email and password are required' });
  }

  try {
    const [users] = await pool.query('SELECT * FROM users WHERE email = ?', [email.trim().toLowerCase()]);
    if (users.length === 0) {
      return res.status(401).json({ error: 'Invalid email or password' });
    }

    const user = users[0];
    if (user.password !== password) {
      return res.status(401).json({ error: 'Invalid email or password' });
    }

    const { password: _, ...userWithoutPass } = user;
    res.json({
      message: 'Login successful',
      user: userWithoutPass
    });
  } catch (err) {
    console.error('Login error:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Register
app.post('/api/auth/register', async (req, res) => {
  const { email, password, full_name, phone } = req.body;
  if (!email || !password || !full_name) {
    return res.status(400).json({ error: 'Name, email, and password are required' });
  }

  try {
    const [existing] = await pool.query('SELECT id FROM users WHERE email = ?', [email.trim().toLowerCase()]);
    if (existing.length > 0) {
      return res.status(400).json({ error: 'User with this email already exists' });
    }

    const [result] = await pool.query(
      'INSERT INTO users (email, password, full_name, phone) VALUES (?, ?, ?, ?)',
      [email.trim().toLowerCase(), password, full_name, phone || '+91 9820123456']
    );

    const newUser = {
      id: result.insertId,
      email: email.trim().toLowerCase(),
      full_name,
      phone: phone || '+91 9820123456'
    };

    res.status(201).json({
      message: 'Registration successful',
      user: newUser
    });
  } catch (err) {
    console.error('Registration error:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// --- PRODUCTS ---
// List all products
app.get('/api/products', async (req, res) => {
  try {
    const [products] = await pool.query('SELECT * FROM products ORDER BY id ASC');
    const parsed = products.map(p => ({
      ...p,
      images: parseJsonField(p.images),
      colors: parseJsonField(p.colors),
      fabrics: parseJsonField(p.fabrics),
      seating_options: parseJsonField(p.seating_options),
      specifications: parseJsonField(p.specifications),
      care_instructions: parseJsonField(p.care_instructions)
    }));
    res.json(parsed);
  } catch (err) {
    console.error('Products error:', err);
    res.status(500).json({ error: 'Failed to fetch products' });
  }
});

// Single product
app.get('/api/products/:id', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM products WHERE id = ? OR slug = ?', [req.params.id, req.params.id]);
    if (rows.length === 0) {
      return res.status(404).json({ error: 'Product not found' });
    }
    const p = rows[0];
    res.json({
      ...p,
      images: parseJsonField(p.images),
      colors: parseJsonField(p.colors),
      fabrics: parseJsonField(p.fabrics),
      seating_options: parseJsonField(p.seating_options),
      specifications: parseJsonField(p.specifications),
      care_instructions: parseJsonField(p.care_instructions)
    });
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch product' });
  }
});

// --- CART ---
// Get user cart
app.get('/api/cart', async (req, res) => {
  const userId = req.headers['x-user-id'] || 1;
  try {
    const [items] = await pool.query(
      `SELECT c.*, p.name AS product_name, p.slug AS product_slug, p.images AS product_images, p.base_price AS product_base_price
       FROM cart_items c
       JOIN products p ON c.product_id = p.id
       WHERE c.user_id = ?
       ORDER BY c.id DESC`,
      [userId]
    );

    const formatted = items.map(item => ({
      id: item.id,
      userId: item.user_id,
      productId: item.product_id,
      name: item.product_name,
      color: item.color,
      fabric: item.fabric,
      seating: item.seating,
      quantity: item.quantity,
      unitPrice: parseFloat(item.unit_price),
      totalPrice: parseFloat(item.total_price),
      image: parseJsonField(item.product_images)?.[0] || ''
    }));

    res.json(formatted);
  } catch (err) {
    console.error('Cart fetch error:', err);
    res.status(500).json({ error: 'Failed to fetch cart' });
  }
});

// Add to cart
app.post('/api/cart', async (req, res) => {
  const userId = req.headers['x-user-id'] || 1;
  const { productId, color, fabric, seating, quantity = 1, unitPrice } = req.body;

  try {
    const qty = Math.max(1, parseInt(quantity, 10));
    const price = parseFloat(unitPrice);
    const total = price * qty;

    // Check if identical item already exists in cart for this user
    const [existing] = await pool.query(
      `SELECT id, quantity FROM cart_items 
       WHERE user_id = ? AND product_id = ? AND color = ? AND fabric = ? AND seating = ?`,
      [userId, productId, color, fabric, seating]
    );

    if (existing.length > 0) {
      const newQty = existing[0].quantity + qty;
      const newTotal = price * newQty;
      await pool.query(
        'UPDATE cart_items SET quantity = ?, total_price = ? WHERE id = ?',
        [newQty, newTotal, existing[0].id]
      );
      return res.json({ message: 'Cart item updated', id: existing[0].id, quantity: newQty });
    }

    const [insertResult] = await pool.query(
      `INSERT INTO cart_items (user_id, product_id, color, fabric, seating, quantity, unit_price, total_price)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [userId, productId, color, fabric, seating, qty, price, total]
    );

    res.status(201).json({ message: 'Item added to cart', id: insertResult.insertId });
  } catch (err) {
    console.error('Add cart error:', err);
    res.status(500).json({ error: 'Failed to add item to cart' });
  }
});

// Update cart item quantity
app.put('/api/cart/:id', async (req, res) => {
  const { quantity } = req.body;
  const itemId = req.params.id;

  try {
    const qty = parseInt(quantity, 10);
    if (qty <= 0) {
      await pool.query('DELETE FROM cart_items WHERE id = ?', [itemId]);
      return res.json({ message: 'Item removed from cart' });
    }

    const [item] = await pool.query('SELECT unit_price FROM cart_items WHERE id = ?', [itemId]);
    if (item.length === 0) return res.status(404).json({ error: 'Item not found' });

    const total = parseFloat(item[0].unit_price) * qty;
    await pool.query('UPDATE cart_items SET quantity = ?, total_price = ? WHERE id = ?', [qty, total, itemId]);
    res.json({ message: 'Cart updated', quantity: qty, totalPrice: total });
  } catch (err) {
    res.status(500).json({ error: 'Failed to update cart item' });
  }
});

// Remove item from cart
app.delete('/api/cart/:id', async (req, res) => {
  try {
    await pool.query('DELETE FROM cart_items WHERE id = ?', [req.params.id]);
    res.json({ message: 'Item deleted' });
  } catch (err) {
    res.status(500).json({ error: 'Failed to remove cart item' });
  }
});

// Clear user cart
app.delete('/api/cart', async (req, res) => {
  const userId = req.headers['x-user-id'] || 1;
  try {
    await pool.query('DELETE FROM cart_items WHERE user_id = ?', [userId]);
    res.json({ message: 'Cart cleared' });
  } catch (err) {
    res.status(500).json({ error: 'Failed to clear cart' });
  }
});

// --- WISHLIST ---
// Get wishlist
app.get('/api/wishlist', async (req, res) => {
  const userId = req.headers['x-user-id'] || 1;
  try {
    const [items] = await pool.query(
      `SELECT w.*, p.name AS product_name, p.slug AS product_slug, p.images AS product_images, p.badge AS product_badge
       FROM wishlist_items w
       JOIN products p ON w.product_id = p.id
       WHERE w.user_id = ?
       ORDER BY w.id DESC`,
      [userId]
    );

    const formatted = items.map(item => ({
      id: item.id,
      userId: item.user_id,
      productId: item.product_id,
      name: item.product_name,
      badge: item.product_badge,
      color: item.color,
      fabric: item.fabric,
      seating: item.seating,
      price: parseFloat(item.price),
      image: parseJsonField(item.product_images)?.[0] || ''
    }));

    res.json(formatted);
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch wishlist' });
  }
});

// Add to wishlist
app.post('/api/wishlist', async (req, res) => {
  const userId = req.headers['x-user-id'] || 1;
  const { productId, color = 'Warm Beige', fabric = 'Belgian Linen', seating = '3 Seater', price } = req.body;

  try {
    // Check if already in wishlist
    const [existing] = await pool.query(
      'SELECT id FROM wishlist_items WHERE user_id = ? AND product_id = ?',
      [userId, productId]
    );

    if (existing.length > 0) {
      // Toggle off / remove
      await pool.query('DELETE FROM wishlist_items WHERE id = ?', [existing[0].id]);
      return res.json({ message: 'Removed from wishlist', isWishlisted: false });
    }

    let itemPrice = price;
    if (!itemPrice) {
      const [prod] = await pool.query('SELECT base_price FROM products WHERE id = ?', [productId]);
      itemPrice = prod.length > 0 ? prod[0].base_price : 42999;
    }

    const [result] = await pool.query(
      `INSERT INTO wishlist_items (user_id, product_id, color, fabric, seating, price)
       VALUES (?, ?, ?, ?, ?, ?)`,
      [userId, productId, color, fabric, seating, itemPrice]
    );

    res.status(201).json({ message: 'Added to wishlist', id: result.insertId, isWishlisted: true });
  } catch (err) {
    console.error('Wishlist error:', err);
    res.status(500).json({ error: 'Failed to update wishlist' });
  }
});

// Remove single wishlist item
app.delete('/api/wishlist/:id', async (req, res) => {
  try {
    await pool.query('DELETE FROM wishlist_items WHERE id = ?', [req.params.id]);
    res.json({ message: 'Wishlist item removed' });
  } catch (err) {
    res.status(500).json({ error: 'Failed to delete wishlist item' });
  }
});

// Clear all wishlist items for user
app.delete('/api/wishlist', async (req, res) => {
  const userId = req.headers['x-user-id'] || 1;
  try {
    await pool.query('DELETE FROM wishlist_items WHERE user_id = ?', [userId]);
    res.json({ message: 'Wishlist cleared' });
  } catch (err) {
    res.status(500).json({ error: 'Failed to clear wishlist' });
  }
});

// Move single wishlist item to cart
app.post('/api/wishlist/move-to-cart', async (req, res) => {
  const userId = req.headers['x-user-id'] || 1;
  const { wishlistId } = req.body;

  try {
    const [wishItem] = await pool.query('SELECT * FROM wishlist_items WHERE id = ?', [wishlistId]);
    if (wishItem.length === 0) return res.status(404).json({ error: 'Item not found' });

    const w = wishItem[0];
    await pool.query(
      `INSERT INTO cart_items (user_id, product_id, color, fabric, seating, quantity, unit_price, total_price)
       VALUES (?, ?, ?, ?, ?, 1, ?, ?)`,
      [userId, w.product_id, w.color, w.fabric, w.seating, w.price, w.price]
    );

    await pool.query('DELETE FROM wishlist_items WHERE id = ?', [wishlistId]);
    res.json({ message: 'Moved to cart' });
  } catch (err) {
    res.status(500).json({ error: 'Failed to move item to cart' });
  }
});

// Move all wishlist items to cart
app.post('/api/wishlist/move-all-to-cart', async (req, res) => {
  const userId = req.headers['x-user-id'] || 1;
  try {
    const [items] = await pool.query('SELECT * FROM wishlist_items WHERE user_id = ?', [userId]);
    for (const w of items) {
      await pool.query(
        `INSERT INTO cart_items (user_id, product_id, color, fabric, seating, quantity, unit_price, total_price)
         VALUES (?, ?, ?, ?, ?, 1, ?, ?)`,
        [userId, w.product_id, w.color, w.fabric, w.seating, w.price, w.price]
      );
    }
    await pool.query('DELETE FROM wishlist_items WHERE user_id = ?', [userId]);
    res.json({ message: 'All items moved to cart', count: items.length });
  } catch (err) {
    res.status(500).json({ error: 'Failed to move all items to cart' });
  }
});

// --- ADDRESSES ---
app.get('/api/addresses', async (req, res) => {
  const userId = req.headers['x-user-id'] || 1;
  try {
    const [addresses] = await pool.query('SELECT * FROM addresses WHERE user_id = ? ORDER BY is_default DESC, id DESC', [userId]);
    res.json(addresses);
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch addresses' });
  }
});

app.post('/api/addresses', async (req, res) => {
  const userId = req.headers['x-user-id'] || 1;
  const { label, recipient_name, phone, street, landmark, city, state, pincode, is_default } = req.body;
  try {
    if (is_default) {
      await pool.query('UPDATE addresses SET is_default = FALSE WHERE user_id = ?', [userId]);
    }
    const [result] = await pool.query(
      `INSERT INTO addresses (user_id, label, recipient_name, phone, street, landmark, city, state, pincode, is_default)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [userId, label || 'Home', recipient_name, phone, street, landmark || '', city, state, pincode, is_default ? 1 : 0]
    );
    res.status(201).json({ message: 'Address saved', id: result.insertId });
  } catch (err) {
    res.status(500).json({ error: 'Failed to save address' });
  }
});

// --- ORDERS ---
// Create order (Checkout)
app.post('/api/orders', async (req, res) => {
  const userId = req.headers['x-user-id'] || 1;
  const {
    recipient_name,
    phone,
    email,
    street,
    landmark,
    city,
    state,
    pincode,
    payment_method,
    subtotal,
    discount = 0,
    total,
    items
  } = req.body;

  try {
    const orderRef = '#SL-' + Math.floor(100000 + Math.random() * 900000);

    const [result] = await pool.query(
      `INSERT INTO orders (order_ref, user_id, recipient_name, phone, email, street, landmark, city, state, pincode, payment_method, subtotal, discount, total, status, items)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'Confirmed', ?)`,
      [
        orderRef,
        userId,
        recipient_name,
        phone,
        email,
        street,
        landmark || '',
        city,
        state,
        pincode,
        payment_method || 'Mock UPI / Net Banking',
        subtotal,
        discount,
        total,
        JSON.stringify(items || [])
      ]
    );

    // Clear cart after successful order
    await pool.query('DELETE FROM cart_items WHERE user_id = ?', [userId]);

    res.status(201).json({
      message: 'Order placed successfully',
      orderId: result.insertId,
      orderRef,
      total,
      estimatedDelivery: 'October 24 – 26, 2025'
    });
  } catch (err) {
    console.error('Order creation error:', err);
    res.status(500).json({ error: 'Failed to place order' });
  }
});

app.get('/api/orders', async (req, res) => {
  const userId = req.headers['x-user-id'] || 1;
  try {
    const [orders] = await pool.query('SELECT * FROM orders WHERE user_id = ? ORDER BY id DESC', [userId]);
    const formatted = orders.map(o => ({
      ...o,
      items: parseJsonField(o.items)
    }));
    res.json(formatted);
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch orders' });
  }
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`\n🛋️  SOFALIVING API Server running at http://localhost:${PORT}`);
  console.log(`📱 Health check: http://localhost:${PORT}/api/health`);
});
