% ORTH_PROJ(A) Returns the projector onto the column space of A
function P = orth_proj(A)
    U = orth(A);
    P = U*U';
end