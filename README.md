cordova-plugin-pdf2png
======================
This is cordova v3.0+ plugin that allows user to get png base64 image from any page of pdf file.

The usage of plugin:
## pdf2png.getPage(pdf,page,callback) 
gets base64 encoded string from page of pdf file

example of usage:

html:
```
<img src='dummy.png' id='myImage' />
```

js:
```
pdf2png.getPage("www/test.pdf",24,function(base64encodedPNG){
    document.getElementById('myImage').src="data:image/png;base64,"+base64encodedPNG;
});
```

this will load page #24 of pdf test.pdf that is stored in www folder into img element with id "myImage",

## pdf2png.getPageInBackground 
does the same thing in background, you should probably use that one



TODO:
* Image size to return
* Comments
* Thanks to other authors
