cordova-plugin-pdf2png
======================
This is cordova v3.0+ plugin that allows user to get png base64 image from any page of pdf file.

The usage of plugin:
## pdf2png.getPage(obj) 
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
    autoRelease:false,
});
```

This will load 300x400px PNG of page #24 of pdf test.pdf that is stored in www folder into img element with id "myImage",
The autoRelease property if set to true, closes pdf and releases memory everytime you request a page.
If set to false (by default) - it leaves pdf opened so next time you get a page from the same pdf for a less amount of time.
Anyway, it will close current pdf automatically if you request a page from another pdf.

## pdf2png.closePDF();
closes PDF and releases memory.

--------------------------------

## pdf2png.getPageInForeground(obj)
does the same thing in foreground, you should probably NOT use this one

--------------------------------

TODO:
* Comments
* Thanks to other authors
* PNG | JPEG formats