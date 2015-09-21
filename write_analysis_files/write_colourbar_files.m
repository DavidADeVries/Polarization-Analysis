function [] = write_colourbar_files(imageMatrix, path, file, scale)

figure;
set(gcf,'Visible','off');
imagesc(imageMatrix),colormap jet,axis image,axis off,colorbar;
caxis(scale);
saveas(gcf, strcat(path, 'Colour/', file, '_scalebar_colour.png'));
colormap gray;
saveas(gcf, strcat(path, 'Greyscale/', file, '_scalebar_greyscale.png'));
close;    

end