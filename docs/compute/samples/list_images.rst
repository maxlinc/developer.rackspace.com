.. code-block:: php

    // To retrieve all images:
    $images = $service->imageList();

    // Choose the first image in the collection
    foreach ($images as $image) {
        $imageId = $image->id;
        break;
    }