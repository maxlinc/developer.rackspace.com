.. code-block:: nodejs

  rackspace.getZones({ name: 'domain.com' }, function (err, zones) {
    if (err) {
      console.dir(err);
      return;
    }
    console.log('Zone ID: ' + zones[0] + '\n');
    console.log('Zone admin email: ' + zones[0] + '\n');
  });

.. code-block:: ruby

  begin
    my_zone = service.zones.all.find {|z| z.name == 'domain.com' }

    puts "Zone ID: #{my_zone.id}"
    puts "Zone admin email: #{my_zone.email}"
  rescue Fog::Rackspace::Errors::ServiceError => e
    puts e.message
  end

.. code-block:: php
	
    $dnsService = $client->dnsService();

    // First define your domain's ID
    $domainId = '{domainId}';

    // Alternatively, if you do not know your domain ID:
    $domains = $dnsService->domainList(array(
        'name' => 'domain.com'
    ));

    foreach ($domains as $domain) {
        $domainId = $domain->id;
        break;
    }

    // Now, to get the full domain object:
    $domain = $dnsService->domain($domainId);