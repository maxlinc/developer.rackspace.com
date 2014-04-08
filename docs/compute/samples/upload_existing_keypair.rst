.. code-block:: php

    $keypair = $service->keypair();

    $keypair->create(array(
       'name'      => 'my_keypair',
       'publicKey' => file_get_contents('~/.ssh/my_server.pub')
    ));