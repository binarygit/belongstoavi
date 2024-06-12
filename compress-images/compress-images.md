# How to compress images before saving in Rails

When attaching images to records you can compress them before attaching.

```
# users controller

compressed_image = ImageProcessing::MiniMagick.strip.quality(85)
                                              .interlace('Plane')
                                              .gaussian_blur('0.05')
                                              .call(params[:photo])
@user.attach(io: compressed_image, filename: params[:photo].original_filename, 
             content_type: 'image/jpeg')
@user.save
```

The compression strategy used here is described in this article:

Using this strategy I was able to compress a 3MB image to 1.5MB.
