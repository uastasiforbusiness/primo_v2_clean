# 🧠 PRIMO_V2 – AI-First Debugging & Coding Standard

> **Propósito**
> Este documento define **cómo un humano o una IA debe razonar, debugear y modificar código** en PRIMO_V2 sin romper la arquitectura ni introducir deuda técnica.

---

## 1. Principios Innegociables

1. La arquitectura **no se negocia**:

   * Hexagonal
   * Clean Architecture
   * BLoC determinista (Evento → Estado)

2. El objetivo del debugging **no es que “funcione”**, sino:

   * identificar la causa raíz
   * corregirla en la capa correcta
   * preservar escalabilidad y auditabilidad

3. Toda solución debe ser:

   * explicable
   * testeable
   * sostenible en el tiempo

---

## 2. Orden Oficial de Análisis (OBLIGATORIO)

El análisis de cualquier bug **SIEMPRE** sigue este orden:

```
UI
 ↓
BLoC
 ↓
Use Case / Regla de Negocio
 ↓
Repository (Interface)
 ↓
RepositoryImpl
 ↓
DataSource (Drift / API)
```

### Prohibiciones explícitas

* Saltar capas
* Arreglar bugs en la UI
* Mover lógica de negocio “para que pase”

---

## 3. Protocolo de Debugging (Cómo razonar)

Antes de proponer **cualquier solución**, se debe identificar explícitamente:

1. **Síntoma observable**

   * qué ve el usuario
   * qué estado falla

2. **Capa afectada**

   * UI / BLoC / Domain / Data

3. **Causa raíz probable**

   * estado mal emitido
   * evento mal manejado
   * persistencia inconsistente
   * violación de una regla de negocio

🚫 Ninguna solución es válida sin este análisis previo.

---

## 4. Reglas de Intervención

### Está permitido

* Ajustar lógica en BLoC
* Corregir contratos de repositorio
* Añadir validaciones de negocio
* Mejorar manejo de estados

### Está prohibido

* Tocar `AuthBloc` para problemas de empleados
* Añadir lógica de negocio en widgets
* Usar `print()` (solo `logger`)
* Usar `dynamic`
* Introducir parches sin justificación causal

---

## 5. Reglas de Código (Contrato Técnico)

* Tipado estricto obligatorio
* Estados inmutables
* Un BLoC = una responsabilidad
* Drift solo vive en `data/`
* El dominio no conoce infraestructura
* Los errores deben ser explícitos (no silenciosos)

---

## 6. Reglas Específicas para IA

Cuando una IA propone una solución, **DEBE**:

1. Explicar **por qué ocurre el bug**
2. Explicar **por qué esta solución es correcta**
3. Explicar **qué alternativa se descartó y por qué**
4. Respetar la arquitectura existente (no reinventarla)

Si no puede cumplir estos puntos → **la solución es inválida**.

---

## 7. Criterio de Aprobación

Una solución solo se considera correcta si:

* Respeta la arquitectura
* No introduce nuevas responsabilidades
* Escala a ventas, auditoría y sincronización
* No rompe el enfoque offline-first

---

## 8. Principio Final

> **“Un bug corregido sin entenderlo
> es un bug que volverá.”**

PRIMO_V2 prioriza:

* claridad
* control
* trazabilidad
  por encima de velocidad improvisada.

