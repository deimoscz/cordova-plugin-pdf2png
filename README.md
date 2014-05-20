cordova-plugin-pdf2png
======================
This is cordova v3.0+ plugin that allows user to get png base64 image from any page of pdf file.

The usage of plugin:
## pdf2png.getPage({pdf:urlToPDF,page:pageNumber,success:function(res){},fail:function(res){},width:pngWidth,height:pngHeight}) 
gets base64 encoded string from page of pdf file

example of usage:

html:
```
<img src='dummy.png' id='myImage' />
```

js:
```
pdf2png.getPage({
    pdf:"www/test.pdf",
    page:24,
    success: function(res){
        document.getElementById('myImage').src="data:image/png;base64,"+res;        
    },
    fail: function(res){
        alert("Failed: "+res);
    },
    width: 300,
    height: 400,
});
```

this will load 300x400px PNG of page #24 of pdf test.pdf that is stored in www folder into img element with id "myImage",

## pdf2png.closePDF();
closes PDF and releases memory.

--------------------------------

## pdf2png.getPageInForeground(obj)
does the same thing in foreground, you should probably NOT use this one

--------------------------------

TODO:
* Comments
* Thanks to other authors
