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

.. code-block:: ruby

  begin
    my_record = my_zone.records.create :name => "subdomain.#{my_zone.domain}",
              :value => '127.0.0.1',
              :type => 'A'

    puts "Record #{my_record.name} was successfully created."
  rescue Fog::Rackspace::Errors::ServiceError => e
    puts e.message
  end

.. code-block:: php

    // Add a CNAME record
    $record = $domain->record(array(
        'type' => 'CNAME',
        'name' => 'www.domain.com',
        'ttl'  => 3600,
        'data' => 'domain.com'
    ));

    $record->create();