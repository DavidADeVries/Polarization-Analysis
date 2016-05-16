dims = size(temp);

result = zeros(dims(1),dims(2));

for i=1:dims(1)
    for j=1:dims(2)
        m = squeeze(temp(i,j,:,:));
        
        s = m(4,3) + m(3,4);
        
        result(i,j) = s;
    end
end