function backprop(varargin)
    for i=1:2:numel(varargin) o.(varargin{i}) = varargin{i+1}; end
    assert(isfield(o,'x'));
    assert(isfield(o,'y'));
    assert(isfield(o,'out'));
    assert(isfield(o,'net'));
    x = h5read(o.x, '/data');
    if ~isfield(o,'batch') o.batch = size(x,2); end
    ymat = h5read(o.y, '/data');
    [~, yvec] = max(ymat);
    o.net = strsplit(o.net, ',');
    for i=1:numel(o.net) net{i} = h5read_layer(o.net{i}); end
    net = copynet(net, 'gpu');
    tic; forwback(net, x(:,1:o.batch), yvec(1:o.batch));
    fprintf(2, '%g seconds\n', toc);
    net = copynet(net, 'cpu');
    for i=1:numel(net)
        fname = sprintf('%s%d.h5', o.out, i);
        try delete(fname); catch; end;
        h5write_layer(fname, net{i});
    end
end

