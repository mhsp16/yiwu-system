-- 异物发现记录表
CREATE TABLE records (
  id BIGSERIAL PRIMARY KEY,
  client_id BIGINT UNIQUE,
  product_name TEXT NOT NULL DEFAULT '',
  batch_no TEXT DEFAULT '',
  workshop TEXT NOT NULL DEFAULT '',
  process TEXT DEFAULT '',
  discover_time TEXT NOT NULL DEFAULT '',
  foreign_type TEXT NOT NULL DEFAULT '',
  discoverer TEXT NOT NULL DEFAULT '',
  risk_level TEXT DEFAULT '',
  description TEXT DEFAULT '',
  source_analysis TEXT DEFAULT '',
  handle_measure TEXT DEFAULT '',
  handle_result TEXT DEFAULT '待处理',
  responsible TEXT DEFAULT '',
  rectification TEXT DEFAULT '',
  remark TEXT DEFAULT '',
  images JSONB DEFAULT '[]',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 系统配置表
CREATE TABLE config (
  id INTEGER PRIMARY KEY DEFAULT 1,
  data JSONB NOT NULL DEFAULT '{}',
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT single_row CHECK (id = 1)
);

-- 插入默认配置
INSERT INTO config (id, data) VALUES (1, '{
  "foreignTypes": ["毛发", "昆虫", "塑料", "玻璃", "金属", "其他异物"],
  "workshops": ["生产二楼车间", "生产三楼车间", "二楼包装车间", "三楼包装车间"],
  "discoverers": ["黄清清", "赵婷婷", "张贵芳", "唐迪兰", "叶连珍", "唐望兰", "凡从艳"],
  "products": ["威化纸", "玉米酥", "拉丝油条", "红枣双色糕", "凤梨果酱", "凤梨酥"],
  "processes": ["包纸", "刮模", "打包", "搅拌", "成型", "烘烤", "冷却"]
}'::jsonb);

-- 启用 RLS（行级安全）
ALTER TABLE records ENABLE ROW LEVEL SECURITY;
ALTER TABLE config ENABLE ROW LEVEL SECURITY;

-- 允许匿名读写（anon key）
CREATE POLICY "Allow anonymous select records" ON records FOR SELECT USING (true);
CREATE POLICY "Allow anonymous insert records" ON records FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow anonymous update records" ON records FOR UPDATE USING (true);
CREATE POLICY "Allow anonymous delete records" ON records FOR DELETE USING (true);

CREATE POLICY "Allow anonymous select config" ON config FOR SELECT USING (true);
CREATE POLICY "Allow anonymous insert config" ON config FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow anonymous update config" ON config FOR UPDATE USING (true);

-- 自动更新 updated_at
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER records_updated_at
  BEFORE UPDATE ON records
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER config_updated_at
  BEFORE UPDATE ON config
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();
