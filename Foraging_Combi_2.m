function newSequence = Foraging_Combi_2 (sequence, nghk)
    nghk = ceil(nghk);
    operator = randi([1 3]);
    switch operator
        case 1  % Do Swap
            newSequence = Swap (sequence, nghk);
        case 2  % Do Reversion
            newSequence = Reversion (sequence, nghk);
        case 3  % Do Insertion
            newSequence = Insertion (sequence, nghk);
    end
end

function newSequence = Swap (sequence, nghk)
    k = numel(sequence);
    i1 = randi([1 k]);
    i2 = i1 + randi([1 nghk]);
    i2(i2>k) = k;
    newSequence = sequence;
    newSequence([i1 i2]) = sequence([i2 i1]);
end

function newSequence = Reversion (sequence, nghk)
    k = numel (sequence);
    i1 = randi ([1 k]);
    i2 = i1 + randi ([1 nghk]);
    i2(i2>k) = k;

    newSequence = sequence;
    newSequence(i1:i2) = sequence(i2:-1:i1);
end

function newSequence = Insertion (sequence, nghk)
    k = numel (sequence);
    a = randi(2);
    switch a
        case 1
            i1 = randi ([1 k]);
        case 2
            i1 = randi ([1 k-1]);
            i1 = [i1 i1+1];
    end
    i2 = i1(end) + randi([-nghk nghk]);
    i2(i2>k) = k;
    i2(i2<1) = 1;

    if i1<i2
        newSequence = [sequence(1:i1-1) sequence(i1+1:i2) sequence([i1]) sequence(i2+1:end)];
    else
        newSequence = [sequence(1:i2) sequence([i1]) sequence(i2+1:i1-1) sequence(i1+1:end)];
    end
end