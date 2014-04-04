
.. code-block:: nodejs
  rackspace.getZones({ name: 'domain.com' }, function (err, zones) {
    if (err) {
      console.dir(err);
      return;
    }
    console.log('Zone ID: ' + zones[0] + '\n');
    console.log('Zone admin email: ' + zones[0] + '\n');
  });