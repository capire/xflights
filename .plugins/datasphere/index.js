const model = require('../../csn.json')

const textAspect = Symbol('text aspect')

// Remove includes as Data Sphere doesn't support them
for (const name in model.definitions) {
  const def = model.definitions[name]
  const includes = def.includes
  if (!includes) continue
  for (const include of includes) {
    const i = model.definitions[include]
    def.elements = { ...def.elements, ...i.elements }
  }
  delete def.includes
}

// Inline custom types to simplify managed association removal
for (const name in model.definitions) {
  const def = model.definitions[name]
  const elements = def.elements
  if (!elements) continue
  for (const col in elements) {
    const element = elements[col]
    const customType = model.definitions[element.type]
    if (!customType) continue
    elements[col] = { ...customType, kind: undefined }
  }
}

// Remove managed association as Data Sphere doesn't support them
for (const name in model.definitions) {
  const def = model.definitions[name]
  const elements = def.elements
  if (!elements) continue
  for (const col in elements) {
    const element = elements[col]

    // Data Sphere doesn't know that value.xpr is a thing that is supposed to be supported
    if (element.value && element.value.xpr) {
      element.xpr = element.value.xpr
      delete element.value
    }
    if (!(element.type in { 'cds.Association': 1, 'cds.Composition': 1 })) continue
    if (!element.keys) continue
    const keys = element.keys
    const on = []
    let first = true
    for (const k of keys) {
      if (first) first = false
      else on.push('and')
      const foreignKey = `${col}_${k.ref[0]}`
      on.push(
        { ref: [col, k.ref[0]] },
        '=',
        { ref: [foreignKey] },
      )
      const target = model.definitions[element.target]
      elements[foreignKey] = { ...target.elements[k.ref[0]], key: element.key }
    }
    delete element.keys
    delete element.key
    element.on = on
  }
}

// Collect all @data.product service to convert to Data Sphere annotation
const dataProductServices = []
for (const name in model.definitions) {
  const def = model.definitions[name]
  if (def.kind !== 'service' || !def['@data.product']) continue
  dataProductServices.push(name)
}

// Just keep entities as Data Sphere doesn't handle the other types
for (const name in model.definitions) {
  const def = model.definitions[name]
  if (def.kind === 'entity') continue
  delete model.definitions[name]
}

// Enhance all the entities with Data Sphere annotations for compatibility
for (const name in model.definitions) {
  const def = model.definitions[name]
  if (def.kind !== 'entity') continue
  delete def['@cds.autoexpose']
  delete def['@cds.persistence.skip']
  def['@DataWarehouse.consumption.external'] = dataProductServices.some(s => name.startsWith(s))
  def['@ObjectModel.modelingPattern'] = { '#': 'DATA_STRUCTURE' }
  def['@ObjectModel.supportedCapabilities'] = [{ '#': 'DATA_STRUCTURE' }]
  if (def.projection) def['@DataWarehouse.sqlEditor.query'] = `SELECT * FROM "${def.projection.from.ref[0]}"`
}



const fs = require('node:fs')
const path = require('node:path')

const dataSphereString = JSON.stringify(model, null, 2)
  .replace(/\.texts"/g, '_texts"')

fs.writeFileSync(
  path.resolve(path.dirname(require.resolve('../../csn.json')), 'datasphere.json'),
  dataSphereString
)
