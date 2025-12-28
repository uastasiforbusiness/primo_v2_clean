# =============================================================================
# GUÍA DE INSTALACIÓN DE SERVIDORES MCP PARA VIBE
# =============================================================================
# Esta guía te ayudará a instalar y configurar los servidores MCP gratuitos
# para potenciar tu desarrollo Flutter con Vibe CLI.
# =============================================================================

## 📦 SERVIDORES MCP INCLUIDOS (No requieren instalación)

### 1. FETCH MCP SERVER
Este servidor viene preinstalado con Vibe y te permite obtener contenido de URLs.
Ideal para consultar documentación de Flutter, Dart, y librerías en tiempo real.

**Uso típico:**
```
"Busca la última versión de Flutter en la documentación oficial"
"Obtén los breaking changes de Flutter 3.24"
```

**Verificación:**
```bash
# Si funciona, debería estar disponible automáticamente
vibe --help | grep fetch
```

---

## 🛠️ SERVIDORES MCP QUE REQUIEREN INSTALACIÓN

### 2. FILESYSTEM MCP SERVER
Proporciona operaciones avanzadas de archivos con mejor manejo de encoding,
búsqueda por patrones, y metadatos extendidos.

**Instalación rápida (recomendada):**
```bash
# Usando npx (requiere Node.js)
npx @smithery/cli install mcp-filesystem-server
```

**Instalación alternativa con pip:**
```bash
# Usando pip
pip install mcp-filesystem-server

# O usando uv
uv pip install mcp-filesystem-server
```

**Verificación:**
```bash
# Probar que está instalado
which filesystem-mcp-server
# o
filesystem-mcp-server --version
```

**Uso típico:**
```
"Busca todos los archivos .dart en el proyecto"
"Lee el archivo de configuración pubspec.yaml"
"Lista los archivos modificados recientemente"
```

---

### 3. SQLITE MCP SERVER (⭐ RECOMENDADO PARA TI)
Perfecto para tu proyecto PRIMO V2 que usa SQLite con Drift. Te permite
ejecutar queries SQL directamente para debugging y análisis de datos.

**Instalación:**
```bash
# Usando uvx (recomendado - no requiere instalación global)
uvx mcp-server-sqlite

# O usando pip
pip install mcp-server-sqlite

# O usando npm
npm install -g mcp-server-sqlite
```

**Para tu proyecto Flutter:**
```bash
# Ejecutar contra tu base de datos de desarrollo
uvx mcp-server-sqlite --db-path ./ruta/a/tu/db.db
```

**Verificación:**
```bash
# Probar instalación
uvx mcp-server-sqlite --help
```

**Uso típico:**
```
"Muéstrame todas las tablas de la base de datos"
"Cuenta cuántos empleados hay en la tabla"
"Muestra los últimos 10 turnos registrados"
"Verifica si existe el usuario admin-001"
```

**Queries útiles para PRIMO V2:**
```sql
-- Ver estructura de empleados
SELECT * FROM employees LIMIT 5;

-- Contar empleados activos
SELECT COUNT(*) FROM employees WHERE is_active = 1;

-- Ver turnos recientes
SELECT * FROM shifts ORDER BY started_at DESC LIMIT 10;

-- Ver eventos de auditoría
SELECT * FROM audit_events ORDER BY created_at DESC LIMIT 20;
```

---

### 4. GITHUB MCP SERVER (OPCIONAL)
Integración completa con GitHub para buscar código, crear issues, y más.
Requiere un Personal Access Token (PAT) de GitHub.

**Generar Token de GitHub:**
1. Ve a: https://github.com/settings/tokens
2. Click en "Generate new token (classic)"
3. Selecciona permisos: `repo`, `read:user`, `user:email`
4. Copia el token generado

**Instalación:**
```bash
# Usando uvx (recomendado)
uvx mcp-github

# Configurar token
export GITHUB_TOKEN="tu_token_aqui"
```

**Verificación:**
```bash
# Probar conexión
uvx mcp-github --help
```

**Uso típico:**
```
"Busca ejemplos de BLoC en repositorios de Flutter"
"Crea un issue en mi repositorio sobre el bug encontrado"
"Encuentra repositorios con arquitectura hexagonal"
```

---

## 🔧 CONFIGURACIÓN AVANZADA

### Variables de Entorno
Añade estas líneas a tu archivo `.bashrc`, `.zshrc`, o equivalente:

```bash
# Para GitHub MCP (opcional)
export GITHUB_TOKEN="ghp_tu_token_aqui"

# Para SQLite MCP (ruta por defecto)
export SQLITE_DB_PATH="$HOME/primo_v2.db"
```

### Verificar que Todo Funciona

```bash
# 1. Verificar Vibe
vibe --version

# 2. Verificar herramientas MCP disponibles
vibe --help

# 3. Probar una query simple
vibe --prompt "Hola, qué herramientas MCP tienes disponibles?"
```

---

## 📋 RESUMEN DE COMANDOS DE INSTALACIÓN

| Servidor | Comando de Instalación | ¿Obligatorio? |
|----------|------------------------|---------------|
| Fetch | Incluido en Vibe | ✅ No |
| Filesystem | `npx @smithery/cli install mcp-filesystem-server` | Opcional |
| SQLite | `uvx mcp-server-sqlite` | ⭐ Recomendado |
| GitHub | `uvx mcp-github` + GITHUB_TOKEN | Opcional |

---

## 🚀 PRIMEROS PASOS RECOMENDADOS

1. **Instala SQLite MCP** (más útil para tu proyecto):
   ```bash
   uvx mcp-server-sqlite --db-path ./primo_v2.db
   ```

2. **Prueba Vibe con el nuevo servidor**:
   ```bash
   cd /ruta/a/primo_v2
   vibe "Muéstrame la estructura de la base de datos"
   ```

3. **Explora las capacidades**:
   ```
   vibe "Ejecuta un SELECT COUNT(*) FROM employees"
   vibe "Busca en la documentación de Flutter sobre BLoC"
   vibe "Lista los archivos más recientes del proyecto"
   ```

---

## ⚠️ NOTAS DE SEGURIDAD

1. **SQLite MCP**: Ten cuidado con queries que modifican datos. Usa `SELECT` para leer.

2. **GitHub Token**: Nunca compartas tu token. Guárdalo en variables de entorno.

3. **Filesystem**: Los permisos de escritura requieren aprobación manual en la configuración.

4. **Fetch**: Solo obtiene contenido, no ejecuta código JavaScript.

---

## 🆘 SOLUCIÓN DE PROBLEMAS

**Error: "mcp-server not found"**
```bash
# Verificar que uvx está instalado
which uvx

# Si no está, instala uv primero
curl -LsSf https://astral.sh/uv/install.sh | sh
```

**Error: "Permission denied" en SQLite**
```bash
# Verificar permisos del archivo de base de datos
ls -la primo_v2.db

# Si es necesario, dar permisos de lectura
chmod 644 primo_v2.db
```

**Vibe no reconoce los servidores MCP**
```bash
# Verificar la configuración
cat ~/.vibe/config.toml

# Reiniciar Vibe para que cargue la configuración
```

---

¡Con estos servidores MCP, tu flujo de desarrollo será mucho más fluido!
El SQLite MCP será especialmente útil para tu proyecto PRIMO V2.
