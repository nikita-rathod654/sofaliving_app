const mysql = require('mysql2/promise');
const fs = require('fs');
const path = require('path');
require('dotenv').config();

const DB_HOST = process.env.DB_HOST || 'localhost';
const DB_PORT = parseInt(process.env.DB_PORT || '3306', 10);
const DB_USER = process.env.DB_USER || 'root';
const DB_PASSWORD = process.env.DB_PASSWORD || '';
const DB_NAME = process.env.DB_NAME || 'sofaliving_db';

const defaultProducts = [
  {
    slug: 'luna-bespoke-sofa',
    name: 'Luna Bespoke Sofa',
    subtitle: 'Sculptural silhouette meets cloud-soft ergonomics',
    category: 'Sofas',
    base_price: 42999.00,
    original_price: 54999.00,
    rating: 4.9,
    review_count: 142,
    badge: 'Bespoke Craft',
    description: 'Sculptural silhouette meets cloud-soft ergonomics. Hand-crafted solid teak frame paired with high-resilience foam and customizable Belgian upholstery.',
    images: JSON.stringify([
      'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=1200&q=80',
      'https://images.unsplash.com/photo-1493663284031-b7e3aefcae8e?auto=format&fit=crop&w=1200&q=80',
      'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?auto=format&fit=crop&w=1200&q=80',
      'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=1200&q=80',
      'https://images.unsplash.com/photo-1567016432779-094069958ea5?auto=format&fit=crop&w=1200&q=80',
      'https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?auto=format&fit=crop&w=1200&q=80'
    ]),
    colors: JSON.stringify([
      { name: 'Warm Beige', hex: '#D8C4B6' },
      { name: 'Forest Emerald', hex: '#2D4B3E' },
      { name: 'Slate Teal', hex: '#415A63' },
      { name: 'Charcoal Night', hex: '#2B2B2B' }
    ]),
    fabrics: JSON.stringify([
      { name: 'Belgian Linen', priceModifier: 0, tag: 'Included' },
      { name: 'Tactile Velvet', priceModifier: 5000, tag: '+₹5,000' },
      { name: 'Nappa Leatherette', priceModifier: 8000, tag: '+₹8,000' }
    ]),
    seating_options: JSON.stringify([
      { name: '2 Seater (Ease)', priceModifier: -7000, tag: '−₹7,000' },
      { name: '3 Seater (Standard)', priceModifier: 0, tag: 'Included' },
      { name: 'L Shape Modular', priceModifier: 18000, tag: '+₹18,000' }
    ]),
    specifications: JSON.stringify({
      dimensions: 'W 220cm x D 98cm x H 78cm',
      seatHeight: '44cm',
      frame: 'FSC-Certified Solid Teak',
      fill: 'Multi-layer High Resilience Foam + Goose Down Blend',
      origin: 'Atelier Handcrafted in India'
    }),
    care_instructions: JSON.stringify({
      cleaning: 'Professional dry clean recommended for Belgian linen.',
      vacuuming: 'Vacuum regularly with a soft brush attachment.',
      sunlight: 'Keep away from direct prolonged midday sun exposure.'
    })
  },
  {
    slug: 'kanso-sectional',
    name: 'Kanso Sectional',
    subtitle: 'Sand Linen · L-Shape Modular System',
    category: 'Sectionals',
    base_price: 64500.00,
    original_price: 72000.00,
    rating: 4.9,
    review_count: 88,
    badge: 'Bespoke',
    description: 'Brushed Taupe Linen Kanso Sectional. Deep proportions with a low Japanese-inspired floating wood base and plush feather-blend cushions.',
    images: JSON.stringify([
      'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=1200&q=80',
      'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=1200&q=80',
      'https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?auto=format&fit=crop&w=1200&q=80'
    ]),
    colors: JSON.stringify([
      { name: 'Slate Grey', hex: '#5A5F63' },
      { name: 'Sand Taupe', hex: '#C2B6A6' },
      { name: 'Oatmeal Boucle', hex: '#E6E1DA' }
    ]),
    fabrics: JSON.stringify([
      { name: 'Belgian Linen', priceModifier: 0, tag: 'Included' },
      { name: 'Tactile Velvet', priceModifier: 5000, tag: '+₹5,000' },
      { name: 'Nappa Leatherette', priceModifier: 8000, tag: '+₹8,000' }
    ]),
    seating_options: JSON.stringify([
      { name: '2 Seater (Ease)', priceModifier: -7000, tag: '−₹7,000' },
      { name: '3 Seater (Standard)', priceModifier: 0, tag: 'Included' },
      { name: 'L Shape Modular', priceModifier: 18000, tag: '+₹18,000' }
    ]),
    specifications: JSON.stringify({
      dimensions: 'W 280cm x D 165cm x H 75cm',
      seatHeight: '42cm',
      frame: 'Kiln-dried White Oak',
      fill: 'High Density Pocket Coils & Down Wrap'
    }),
    care_instructions: JSON.stringify({
      cleaning: 'Spot clean with mild water-free solvent.',
      vacuuming: 'Fluff cushions weekly.'
    })
  },
  {
    slug: 'oslo-modular',
    name: 'Oslo Modular',
    subtitle: 'Flexible 3-piece layout engineered with cloud-soft comfort',
    category: 'Modular',
    base_price: 52000.00,
    original_price: 59000.00,
    rating: 4.9,
    review_count: 94,
    badge: 'Modular Config',
    description: 'Flexible 3-piece layout engineered with cloud-soft comfort and high-density pocket cores for endlessly adaptable living rooms.',
    images: JSON.stringify([
      'https://images.unsplash.com/photo-1493663284031-b7e3aefcae8e?auto=format&fit=crop&w=1200&q=80',
      'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=1200&q=80'
    ]),
    colors: JSON.stringify([
      { name: 'Warm Beige', hex: '#D8C4B6' },
      { name: 'Charcoal Night', hex: '#2B2B2B' },
      { name: 'Forest Emerald', hex: '#2D4B3E' }
    ]),
    fabrics: JSON.stringify([
      { name: 'Belgian Linen', priceModifier: 0, tag: 'Included' },
      { name: 'Tactile Velvet', priceModifier: 5000, tag: '+₹5,000' },
      { name: 'Nappa Leatherette', priceModifier: 8000, tag: '+₹8,000' }
    ]),
    seating_options: JSON.stringify([
      { name: '2 Seater (Ease)', priceModifier: -7000, tag: '−₹7,000' },
      { name: '3 Seater (Standard)', priceModifier: 0, tag: 'Included' },
      { name: 'L Shape Modular', priceModifier: 18000, tag: '+₹18,000' }
    ]),
    specifications: JSON.stringify({
      dimensions: 'W 240cm x D 105cm x H 76cm',
      seatHeight: '43cm',
      frame: 'Solid Ash Wood'
    }),
    care_instructions: JSON.stringify({
      cleaning: 'Removable zip covers suitable for gentle dry clean.'
    })
  },
  {
    slug: 'haven-velvet-accent-chair',
    name: 'Haven Velvet Accent Chair',
    subtitle: 'Olive Green · Single Armchair · Matte Velvet',
    category: 'Armchairs',
    base_price: 24999.00,
    original_price: 29999.00,
    rating: 4.8,
    review_count: 63,
    badge: 'Restock',
    description: 'Explore hand-stitched curved silhouettes and rich Japanese cedar framework tailored for mindful living.',
    images: JSON.stringify([
      'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?auto=format&fit=crop&w=1200&q=80',
      'https://images.unsplash.com/photo-1567016432779-094069958ea5?auto=format&fit=crop&w=1200&q=80'
    ]),
    colors: JSON.stringify([
      { name: 'Forest Emerald', hex: '#2D4B3E' },
      { name: 'Warm Beige', hex: '#D8C4B6' },
      { name: 'Slate Teal', hex: '#415A63' }
    ]),
    fabrics: JSON.stringify([
      { name: 'Belgian Linen', priceModifier: 0, tag: 'Included' },
      { name: 'Tactile Velvet', priceModifier: 5000, tag: '+₹5,000' }
    ]),
    seating_options: JSON.stringify([
      { name: 'Single Accent', priceModifier: 0, tag: 'Standard' }
    ]),
    specifications: JSON.stringify({
      dimensions: 'W 85cm x D 88cm x H 80cm',
      seatHeight: '45cm',
      frame: 'Solid Japanese Cedar'
    }),
    care_instructions: JSON.stringify({
      cleaning: 'Gently brush velvet with velvet brush in pile direction.'
    })
  },
  {
    slug: 'aura-curved-chaise',
    name: 'Aura Curved Chaise Lounge',
    subtitle: 'Organic sculpted curves crafted with Italian bouclé',
    category: 'Sofas',
    base_price: 58000.00,
    original_price: 66000.00,
    rating: 4.9,
    review_count: 41,
    badge: 'Artisan Workshop',
    description: 'Sensual curved lines meet relaxed architectural posture. Perfect for spacious open floor living rooms.',
    images: JSON.stringify([
      'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=1200&q=80',
      'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=1200&q=80'
    ]),
    colors: JSON.stringify([
      { name: 'Warm Beige', hex: '#D8C4B6' },
      { name: 'Slate Teal', hex: '#415A63' }
    ]),
    fabrics: JSON.stringify([
      { name: 'Belgian Linen', priceModifier: 0, tag: 'Included' },
      { name: 'Tactile Velvet', priceModifier: 5000, tag: '+₹5,000' }
    ]),
    seating_options: JSON.stringify([
      { name: '3 Seater Curved', priceModifier: 0, tag: 'Standard' },
      { name: 'L Shape Modular', priceModifier: 18000, tag: '+₹18,000' }
    ]),
    specifications: JSON.stringify({
      dimensions: 'W 260cm x D 120cm x H 76cm',
      seatHeight: '42cm'
    }),
    care_instructions: JSON.stringify({
      cleaning: 'Professional upholstery cleaning only.'
    })
  },
  {
    slug: 'kyoto-low-profile-recliner',
    name: 'Kyoto Low-Profile Recliner',
    subtitle: 'Silent German-engineered mechanical reclining glider',
    category: 'Recliners',
    base_price: 39500.00,
    original_price: 45000.00,
    rating: 4.7,
    review_count: 76,
    badge: 'Minimalist',
    description: 'Concealed power recline function maintains clean architectural silhouettes without compromising ergonomic support.',
    images: JSON.stringify([
      'https://images.unsplash.com/photo-1567016432779-094069958ea5?auto=format&fit=crop&w=1200&q=80',
      'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?auto=format&fit=crop&w=1200&q=80'
    ]),
    colors: JSON.stringify([
      { name: 'Charcoal Night', hex: '#2B2B2B' },
      { name: 'Warm Beige', hex: '#D8C4B6' }
    ]),
    fabrics: JSON.stringify([
      { name: 'Belgian Linen', priceModifier: 0, tag: 'Included' },
      { name: 'Nappa Leatherette', priceModifier: 8000, tag: '+₹8,000' }
    ]),
    seating_options: JSON.stringify([
      { name: 'Single Recliner', priceModifier: 0, tag: 'Standard' }
    ]),
    specifications: JSON.stringify({
      dimensions: 'W 92cm x D 100cm (recline 160cm) x H 90cm',
      seatHeight: '46cm'
    }),
    care_instructions: JSON.stringify({
      cleaning: 'Wipe clean with soft microfiber cloth.'
    })
  }
];

async function initDatabase() {
  console.log('Connecting to MySQL on ' + DB_HOST + ':' + DB_PORT + ' as ' + DB_USER + '...');
  let connection;
  try {
    connection = await mysql.createConnection({
      host: DB_HOST,
      port: DB_PORT,
      user: DB_USER,
      password: DB_PASSWORD,
      multipleStatements: true,
       ssl: process.env.DB_SSL === 'true'
        ? { ca: fs.readFileSync(path.join(__dirname, 'certs', 'ca_sofaliving.pem') ) }
        : undefined
    });
    console.log('Connected to MySQL server successfully!');

    // Read and run schema.sql
    const schemaSql = fs.readFileSync(path.join(__dirname, 'schema.sql'), 'utf-8');
    console.log('Executing schema.sql...');
    await connection.query(schemaSql);
    console.log('Database and tables created / verified successfully.');

    // Switch to sofaliving_db
    await connection.changeUser({ database: DB_NAME });

    // Seed products
    console.log('Seeding products...');
    for (const p of defaultProducts) {
      await connection.query(
        `INSERT INTO products (slug, name, subtitle, category, base_price, original_price, rating, review_count, badge, description, images, colors, fabrics, seating_options, specifications, care_instructions)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
         ON DUPLICATE KEY UPDATE
           name = VALUES(name),
           subtitle = VALUES(subtitle),
           category = VALUES(category),
           base_price = VALUES(base_price),
           original_price = VALUES(original_price),
           rating = VALUES(rating),
           review_count = VALUES(review_count),
           badge = VALUES(badge),
           description = VALUES(description),
           images = VALUES(images),
           colors = VALUES(colors),
           fabrics = VALUES(fabrics),
           seating_options = VALUES(seating_options),
           specifications = VALUES(specifications),
           care_instructions = VALUES(care_instructions)`,
        [
          p.slug, p.name, p.subtitle, p.category, p.base_price, p.original_price,
          p.rating, p.review_count, p.badge, p.description, p.images, p.colors,
          p.fabrics, p.seating_options, p.specifications, p.care_instructions
        ]
      );
    }
    console.log('Products seeded.');

    // Seed Demo User Aarav Mehta
    console.log('Seeding Demo User (aarav.mehta@example.com)...');
    const [userRows] = await connection.query('SELECT id FROM users WHERE email = ?', ['aarav.mehta@example.com']);
    let demoUserId;
    if (userRows.length === 0) {
      const [insertUser] = await connection.query(
        'INSERT INTO users (email, password, full_name, phone) VALUES (?, ?, ?, ?)',
        ['aarav.mehta@example.com', 'password123', 'Aarav Mehta', '+91 9820123456']
      );
      demoUserId = insertUser.insertId;
      console.log('Demo user created with ID: ' + demoUserId);
    } else {
      demoUserId = userRows[0].id;
      console.log('Demo user exists with ID: ' + demoUserId);
    }

    // Seed Addresses for Demo User
    const [addrRows] = await connection.query('SELECT id FROM addresses WHERE user_id = ?', [demoUserId]);
    if (addrRows.length === 0) {
      await connection.query(
        `INSERT INTO addresses (user_id, label, recipient_name, phone, street, landmark, city, state, pincode, is_default)
         VALUES 
         (?, 'Home', 'Aarav Mehta', '+91 9820123456', '402, Lotus Grandeur, 14th Road', 'Near Joggers Park, Bandra West', 'Mumbai', 'Maharashtra', '400050', TRUE),
         (?, 'Office - BKC', 'Aarav Mehta', '+91 9820123456', 'G Block, Bandra Kurla Complex', 'Near Diamond Bourse', 'Mumbai', 'Maharashtra', '400051', FALSE)`,
        [demoUserId, demoUserId]
      );
      console.log('Demo addresses seeded.');
    }

    // Seed Cart Items for Demo User (matching UI screenshot: Luna 48,499 + Kanso 71,999)
    const [cartRows] = await connection.query('SELECT id FROM cart_items WHERE user_id = ?', [demoUserId]);
    if (cartRows.length === 0) {
      const [lunaProd] = await connection.query('SELECT id FROM products WHERE slug = ?', ['luna-bespoke-sofa']);
      const [kansoProd] = await connection.query('SELECT id FROM products WHERE slug = ?', ['kanso-sectional']);

      if (lunaProd.length > 0) {
        await connection.query(
          `INSERT INTO cart_items (user_id, product_id, color, fabric, seating, quantity, unit_price, total_price)
           VALUES (?, ?, 'Warm Beige', 'Belgian Linen', '3 Seater', 1, 48499.00, 48499.00)`,
          [demoUserId, lunaProd[0].id]
        );
      }
      if (kansoProd.length > 0) {
        await connection.query(
          `INSERT INTO cart_items (user_id, product_id, color, fabric, seating, quantity, unit_price, total_price)
           VALUES (?, ?, 'Slate Grey', 'Tactile Velvet', 'L Shape Modular', 1, 71999.00, 71999.00)`,
          [demoUserId, kansoProd[0].id]
        );
      }
      console.log('Demo cart items seeded.');
    }

    // Seed Wishlist Items for Demo User (matching UI screenshot: Luna, Kanso, Haven)
    const [wishRows] = await connection.query('SELECT id FROM wishlist_items WHERE user_id = ?', [demoUserId]);
    if (wishRows.length === 0) {
      const [lunaProd] = await connection.query('SELECT id FROM products WHERE slug = ?', ['luna-bespoke-sofa']);
      const [kansoProd] = await connection.query('SELECT id FROM products WHERE slug = ?', ['kanso-sectional']);
      const [havenProd] = await connection.query('SELECT id FROM products WHERE slug = ?', ['haven-velvet-accent-chair']);

      if (lunaProd.length > 0) {
        await connection.query(
          `INSERT INTO wishlist_items (user_id, product_id, color, fabric, seating, price)
           VALUES (?, ?, 'Warm Beige', 'Belgian Linen', '3 Seater', 48499.00)`,
          [demoUserId, lunaProd[0].id]
        );
      }
      if (kansoProd.length > 0) {
        await connection.query(
          `INSERT INTO wishlist_items (user_id, product_id, color, fabric, seating, price)
           VALUES (?, ?, 'Sand Taupe', 'Belgian Linen', 'L Shape Modular', 68499.00)`,
          [demoUserId, kansoProd[0].id]
        );
      }
      if (havenProd.length > 0) {
        await connection.query(
          `INSERT INTO wishlist_items (user_id, product_id, color, fabric, seating, price)
           VALUES (?, ?, 'Forest Emerald', 'Tactile Velvet', 'Single Accent', 24999.00)`,
          [demoUserId, havenProd[0].id]
        );
      }
      console.log('Demo wishlist items seeded.');
    }

    console.log('\n--- SOFALIVING MySQL INITIALIZATION COMPLETE! ---');
  } catch (err) {
    console.error('Error during database initialization:', err.message);
  } finally {
    if (connection) await connection.end();
  }
}

initDatabase();
