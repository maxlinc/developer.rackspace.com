.. code-block:: nodejs

  rackspace.getRecord(myZone, 'myRecord-id', function (err, rec) {
    if (err) {
      console.dir(err);
      return;
    }
    console.log('Record ' + rec.name + ' was successfully retrieved.');
  });

.. code-block:: ruby

  begin
    my_record = my_zone.records.get RECORD_ID

    puts "Record #{my_record.name} was successfully retrieved."
  rescue Fog::Rackspace::Errors::ServiceError => e
    puts e.message
  end

.. code-block:: php

    // First define your record's ID
    $recordId = '{recordId}';

    // Alternatively, if you do not know your record ID:
    $records = $domain->recordList(array(
        'name' => 'imap.example.com',
        'type' => 'MX'
    ));

    foreach ($records as $record) {
        $recordId = $record->id;
        break;
    }

    // Now, to get the full record object:
    $record = $domain->record($recordId);