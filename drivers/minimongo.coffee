window.nmMinimongoDriver = (db) ->

  addCollection: (collection) ->
    console.log 'minimongodriver:addCollection', collection,
    db.addCollection collection

  addDocument: (collection, document) ->
    console.log 'minimongodriver:addDocument', collection, document
    db[collection].upsert document
