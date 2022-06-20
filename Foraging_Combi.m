function newSequence = Foraging_Combi (sequence)
    operator = randi([1 3]);
    switch operator
        case 1  % Do Swap
            newSequence = Swap (sequence);
        case 2  % Do Reversion
            newSequence = Reversion (sequence);
        case 3  % Do Insertion
            newSequence = Insertion (sequence);
    end
end

function newSequence = Swap(sequence)
    k = numel(sequence);
    I  =  randsample(k, 2);
    i1 = I(1);
    i2 = I(2);
    newSequence = sequence;
    newSequence([i1 i2]) = sequence([i2 i1]);
end
function newSequence = Reversion(sequence)
    k = numel(sequence);
    I = randsample(k, 2);
    i1 = min(I);
    i2 = max(I);
    newSequence = sequence;
    newSequence(i1:i2) = sequence(i2:-1:i1);
end
function newSequence = Insertion(sequence)
    k = numel(sequence);
    I = randsample(k, 2);
    i1 = I(1);
    i2 = I(2);
    if i1 < i2
        newSequence = [sequence(1:i1-1) sequence(i1+1:i2) sequence([i1]) sequence(i2+1:end)];
    else
        newSequence = [sequence(1:i2) sequence([i1]) sequence(i2+1:i1-1) sequence(i1+1:end)];
    end
end