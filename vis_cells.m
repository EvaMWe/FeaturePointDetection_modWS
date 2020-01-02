function vis_cells(image,BW,varargin)

if nargin == 3
    titel = varargin{1};
    figure ('Name',titel)
else
    figure
end
maxi = max(image(:));
mini = min(image(:));
I_stack = (image-mini)/(maxi-mini);
I_stack = repmat(I_stack,[1 1 3]);

BW_log = logical(BW);
I_stack(BW_log) = 2;
I_stack(I_stack(:,:,1) == 2) = 1;
I_stack(I_stack(:,:,2) == 2) = 0.2;
I_stack(I_stack(:,:,3) == 2) = 0.2;

imshow(I_stack);
end