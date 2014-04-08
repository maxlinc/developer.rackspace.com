.. code-block:: nodejs
  
  rackspace.createContainer({
    name: 'sample-container-test',
    metadata: {
      callme: 'maybe'
    }
  }, function (err, container) {
    if (err) {
      console.dir(err);
      return;
    }

    console.log(container.name);
    console.log(container.metadata);
  });