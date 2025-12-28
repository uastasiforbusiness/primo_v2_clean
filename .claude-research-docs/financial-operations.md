# Financial Operations

## Atomic Transactions

TODA operación de dinero debe ser atómica:

await database.transaction(() async {
await database.insertShift(...);
await database.insertAuditEvent(...);
});

text

## Audit Trail

Eventos críticos a registrar:
- CLOCK_IN
- CLOCK_OUT
- CASH_ADJUSTMENT
- EMPLOYEE_CREATED
Paso 5: Backup y Reemplazar CLAUDE.md (1 minuto)
bash
# Hacer backup del original
cp CLAUDE.md CLAUDE.md.backup

# Ahora edita tu CLAUDE.md
# Reemplázalo con la versión optimizada del archivo que descargaste
# (Sección "CLAUDE.md Optimizado" en configuracion-claude-code-primo-v2.md)
Paso 6: Validar Instalación (1 minuto)
bash
# Verifica que todo esté creado
ls -la .claude/
# Debes ver: config.json, .mcpServers.json, context-index.md, commands/

ls -la .claude/commands/
# Debes ver: database.claude, architecture.claude, blocs.claude, debugging.claude

ls -la .claude-research-docs/
# Debes ver: drift-guide.md, bloc-patterns.md, financial-operations.md
Paso 7: Probar en Claude Code (1 minuto)
Abre Claude Code (https://claude.ai/code o tu IDE)

Abre tu proyecto PRIMO_V2

Ejecuta este comando:

text
/init --profile=flutter-pos
Resultado esperado:

text
✅ Context loaded: ~8,000 tokens
✅ Config loaded from .claude/config.json
✅ 4 custom commands available
✅ Ready to develop!
Paso 8: Primeras Pruebas (2 minutos)
Ejecuta estos comandos para validar:

text
/db-schema
Debería listar todas las tablas de tu database.

text
/arch-flow "ClockIn"
Debería trazar el flujo completo del Clock In.

text
/bloc-event
Debería ayudarte a generar un nuevo Event.

✅ Checklist Final
 Directorios creados (.claude/, .claude-research-docs/)

 10 archivos creados (config, commands, research docs)

 CLAUDE.md respaldado

 Comandos funcionan en Claude Code

 Context load ~8,000 tokens


