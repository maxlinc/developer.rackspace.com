
.. code-block:: nodejs
  var details = {
  name: 'domain.com',
  email: 'admin@domain.com',
  ttl: 300,
  comment: 'root level for domain.com'
  };

  rackspace.createZone(details, function (err, zone) {
    if (err) {
      console.dir(err);
      return;
    }
    console.log(zone.id + ' ' + zone.name + ' ' + zone.ttl);
  });