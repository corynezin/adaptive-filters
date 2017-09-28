% matrix_dist(A,B) returns the "distance" between the column spaces of A and B
function d = matrix_dist(A,B)
    d = norm( orth_proj(A) - orth_proj(B) );
end