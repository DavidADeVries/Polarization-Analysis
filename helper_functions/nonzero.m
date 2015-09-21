function newimage = nonzero(oldimage);

[m,n]=size(oldimage);

bound = 0.000001;

for i=1:m
    for j=1:n
        if (oldimage(i,j)< bound) && (oldimage(i,j) > -bound)
            newimage(i,j) = bound;
        else
            newimage(i,j) = oldimage(i,j);
        end;
    end;
end;