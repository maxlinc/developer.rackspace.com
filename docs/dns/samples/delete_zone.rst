.. code-block:: nodejs
  
  rackspace.deleteZone(myZone, function (err) {
    if (err) {
      console.dir(err);
      return;
    }
    console.log('Zone successfully deleted.');
  });

.. code-block:: ruby

  begin
    my_zone.destroy

    puts 'Zone successfully deleted.'
  rescue Fog::Rackspace::Errors::ServiceError => e
    puts e.message
  end

.. code-block:: php

	$domain->delete();
