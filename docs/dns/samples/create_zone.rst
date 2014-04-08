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

.. code-block:: ruby

  begin
    my_zone = service.zones.create :domain => 'domain.com',
              :email => 'admin@domain.com',
              :ttl => 300,
              :comment => 'root level for domain.com'

    puts "Zone ID #{my_zone.id} for #{my_zone.name} was successfully created."
  rescue Fog::Rackspace::Errors::ServiceError => e
    puts e.message
  end

.. code-block:: php

    $dnsService = $client->dnsService();

    $domain = $dnsService->domain();
    $domain->create(array(
        'name'         => 'domain.com',
        'emailAddress' => 'admin@domain.com',
        'ttl'          => 300,
        'comment'      => 'Root level for domain.com'
    ));
