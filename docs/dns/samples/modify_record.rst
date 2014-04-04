
.. code-block:: nodejs
  
  myRec.data = '192.168.1.1';
  rackspace.updateRecord(myZone, myRec, function (err){
    if (err) {
      console.dir(err);
      return;
    }
    console.log('Record ' + myRec.name + ' was sucessfully modified.');
  });