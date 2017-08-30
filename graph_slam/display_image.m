function display_image(img, index, frame)
% David Z, 3/4/2015, 
% display a img in the figure 
    figure(1);
    subplot(2,2,index);
    imagesc(img); colormap(gray); axis image;
    set(gca,'XTick',[]);
    set(gca,'YTick',[]);
    title(sprintf('Frame %d', frame));
    % drawnow;
end