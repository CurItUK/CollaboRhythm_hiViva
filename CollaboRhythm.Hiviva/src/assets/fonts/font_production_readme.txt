1. download and install 'Bitmap Font Generator' from 'http://www.angelcode.com/products/bmfont/' as recommended by 
2. in Options>Font Settings, select desired font, size and select 'Render from TrueType outline' and select 'do not include kerning pairs'  and select 'Match char height' press ok
3. in Options>Export Options, add Padding if you need to apply an effect that extends character borders. Select '32' Bit depth for alpha background and choose the correct Width and Height to ensure all characters fit within one png (trial and error). For 'Presets:' select 'White text with alpha'. Select 'XML' Font descriptor. Select png Texture. press ok
4. Options>Save bitmap font as... to export the font .png and atlas .xml
5. (Optional) import resulting .png into PhotoShop to add layer effects inline with designs.
6. Rename the 'face' attribute in the resulting atlas xml. this value is the same value you will use to reference the font in Starling. Ensure the 'size' attribute is NOT and negative value, if it is simpley remove the hyphen.
7. Embed into air app via AssetsManager and reference using "TextField.getBitmapFont(<'face' value>)" and "new BitmapFontTextFormat(this.engravedBoldBitmapFont,30,Color.WHITE);" (Color.WHITE for native colour)
