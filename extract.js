const fs = require('fs');
const html = fs.readFileSync('C:\\Users\\guoyu\\AppData\\Roaming\\VClaw\\.openclaw\\workspace\\异物系统\\食品生产车间异物发现统计分析系统-云同步版.html', 'utf8');
const m = html.match(/<script>([\s\S]*?)<\/script>/);
if (m) {
  fs.writeFileSync('C:\\Users\\guoyu\\AppData\\Local\\Temp\\check_syntax.js', m[1], 'utf8');
  console.log('JS extracted, length:', m[1].length);
}
