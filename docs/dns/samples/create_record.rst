
.. code-block:: nodejs
    
  var recDetails = {
    name: 'subdomain',
    data: '127.0.0.1',
    type: 'A'
  };

  rackspace.createRecord(myZone, recDetails, function (err, rec) {
    if (err) {
      console.dir(err);
      return;
    }
    console.log('Record ' + rec.name + ' was successfully created.');
  });