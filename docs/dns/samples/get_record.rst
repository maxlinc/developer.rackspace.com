
.. code-block:: nodejs

  rackspace.getRecord(myZone, 'myRecord-id', function (err, rec) {
    if (err) {
      console.dir(err);
      return;
    }
    console.log('Record ' + rec.name + ' was successfully retrieved.');
  });