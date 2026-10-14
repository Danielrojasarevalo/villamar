const { spawn } = require('child_process');
const path = require('path');

const projectRoot = __dirname;
const backendDir = path.join(projectRoot, 'backend', 'inventario');
const frontendDir = path.join(projectRoot, 'proyecto sistema de inventario de abonos ', 'inventariofront');

console.log('\n\x1b[34m🚀 Iniciando backend y frontend...\x1b[0m\n');

// Iniciar Backend
console.log('\x1b[32m📦 Iniciando Backend (Django)...\x1b[0m');
const pythonPath = path.join(backendDir, 'venv', 'bin', 'python');
const backend = spawn(pythonPath, ['manage.py', 'runserver', '--noreload'], {
  cwd: backendDir,
  stdio: 'inherit',
  shell: false
});

// Pequeña pausa para que el backend se inicie
setTimeout(() => {
  console.log('\x1b[32m🎨 Iniciando Frontend (Angular)...\x1b[0m\n');
  
  // Iniciar Frontend
  const frontend = spawn('npm', ['start'], {
    cwd: frontendDir,
    stdio: 'inherit',
    shell: true
  });

  frontend.on('error', (err) => {
    console.error('\x1b[31m❌ Error en Frontend:\x1b[0m', err);
  });

  frontend.on('close', (code) => {
    console.log(`\x1b[33m⚠️  Frontend terminado con código ${code}\x1b[0m`);
    backend.kill();
    process.exit(code);
  });
}, 1500);

backend.on('error', (err) => {
  console.error('\x1b[31m❌ Error en Backend:\x1b[0m', err);
});

backend.on('close', (code) => {
  console.log(`\x1b[33m⚠️  Backend terminado con código ${code}\x1b[0m`);
  process.exit(code);
});

// Manejar Ctrl+C
process.on('SIGINT', () => {
  console.log('\n\x1b[34m🛑 Deteniendo servicios...\x1b[0m\n');
  backend.kill();
  process.exit(0);
});
