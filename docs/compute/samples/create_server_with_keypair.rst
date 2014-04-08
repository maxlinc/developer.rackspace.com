.. code-block:: php

    use Guzzle\Http\Exception\BadResponseException;

    $server = $compute->server();

    try {
        $response = $server->create(array(
            'name'     => 'My new server',
            'imageId'  => $imageId,
            'flavorId' => $flavorId
            'keypair'  => 'my_keypair'
        ));
    } catch (BadResponseException $e) {
        // No! Something failed. Let's find out:
        printf("Request: %s\n\nResponse: %s", (string) $e->getRequest(), (string) $e->getResponse());
    }