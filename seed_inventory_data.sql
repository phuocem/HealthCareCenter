-- 1. Xóa sạch dữ liệu cũ để tránh trùng lặp khóa ngoại hoặc dư thừa dữ liệu
TRUNCATE public.inventory_batches, public.inventory_items CASCADE;

-- 2. Thêm dữ liệu vào bảng inventory_items và tự động lấy ID được sinh ra để thêm vào inventory_batches
WITH inserted_items AS (
  INSERT INTO public.inventory_items (name, is_prescription_required, image_url)
  VALUES
    ('Panadol Extra', false, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=200&auto=format&fit=crop&q=80'),
    ('Decolgen ND', false, 'https://images.unsplash.com/photo-1576091160550-2173dba999ef?w=200&auto=format&fit=crop&q=80'),
    ('Hapacol 150', false, 'https://images.unsplash.com/photo-1607619056574-7b8f304b3c93?w=200&auto=format&fit=crop&q=80'),
    ('Efferalgan 500mg', false, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=200&auto=format&fit=crop&q=80'),
    ('Aspirin 81mg', false, 'https://images.unsplash.com/photo-1628771065518-0d82f15e8562?w=200&auto=format&fit=crop&q=80'),
    ('Nexium 40mg', true, 'https://images.unsplash.com/photo-1584017911766-d451b3d0e843?w=200&auto=format&fit=crop&q=80'),
    ('Amoxicillin 500mg', true, 'https://images.unsplash.com/photo-1616679911721-eff6eec18fcd?w=200&auto=format&fit=crop&q=80'),
    ('Paracetamol 500mg', false, 'https://images.unsplash.com/photo-1526256262350-7da7584cf5eb?w=200&auto=format&fit=crop&q=80'),
    ('Strepsils Cool', false, 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=200&auto=format&fit=crop&q=80'),
    ('Berberin 50mg', false, 'https://images.unsplash.com/photo-1607619056574-7b8f304b3c93?w=200&auto=format&fit=crop&q=80'),
    ('Gaviscon Dual Action', false, 'https://images.unsplash.com/photo-1576091160550-2173dba999ef?w=200&auto=format&fit=crop&q=80'),
    ('Boganic Forte', false, 'https://images.unsplash.com/photo-1628771065518-0d82f15e8562?w=200&auto=format&fit=crop&q=80'),
    ('Vitamin C 500mg (Hết hạn)', false, 'https://images.unsplash.com/photo-1616679911721-eff6eec18fcd?w=200&auto=format&fit=crop&q=80'),
    ('Augmentin 625mg (Hết hạn)', true, 'https://images.unsplash.com/photo-1584017911766-d451b3d0e843?w=200&auto=format&fit=crop&q=80'),
    ('Cefuroxim 500mg (Hết hạn)', true, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=200&auto=format&fit=crop&q=80')
  RETURNING id, name
)
INSERT INTO public.inventory_batches (item_id, quantity, expiry_date)
SELECT 
  id as item_id,
  CASE 
    WHEN name = 'Panadol Extra' THEN 320
    WHEN name = 'Nexium 40mg' THEN 15
    WHEN name = 'Amoxicillin 500mg' THEN 8
    WHEN name = 'Hapacol 150' THEN 240
    WHEN name = 'Gaviscon Dual Action' THEN 0
    WHEN name = 'Boganic Forte' THEN 90
    WHEN name = 'Vitamin C 500mg (Hết hạn)' THEN 40
    WHEN name = 'Augmentin 625mg (Hết hạn)' THEN 20
    WHEN name = 'Cefuroxim 500mg (Hết hạn)' THEN 10
    ELSE 150
  END as quantity,
  CASE 
    WHEN name = 'Vitamin C 500mg (Hết hạn)' THEN '2026-04-10'::date
    WHEN name = 'Augmentin 625mg (Hết hạn)' THEN '2026-03-15'::date
    WHEN name = 'Cefuroxim 500mg (Hết hạn)' THEN '2026-01-01'::date
    ELSE (CURRENT_DATE + INTERVAL '400 days')::date
  END as expiry_date
FROM inserted_items;
