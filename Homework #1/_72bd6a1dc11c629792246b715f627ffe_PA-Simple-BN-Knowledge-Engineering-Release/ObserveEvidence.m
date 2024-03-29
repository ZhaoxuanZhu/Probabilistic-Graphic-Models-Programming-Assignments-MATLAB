% ObserveEvidence Modify a vector of factors given some evidence.
%   F = ObserveEvidence(F, E) sets all entries in the vector of factors, F,
%   that are not consistent with the evidence, E, to zero. F is a vector of
%   factors, each a data structure with the following fields:
%     .var    Vector of variables in the factor, e.g. [1 2 3]
%     .card   Vector of cardinalities corresponding to .var, e.g. [2 2 2]
%     .val    Value table of size prod(.card)
%   E is an N-by-2 matrix, where each row consists of a variable/value pair. 
%     Variables are in the first column and values are in the second column.

function F = ObserveEvidence(F, E)

% Iterate through all evidence

for i = 1:size(E, 1),
    v = E(i, 1); % variable
    x = E(i, 2); % value

    % Check validity of evidence
    if (x == 0),
        warning(['Evidence not set for variable ', int2str(v)]);
        continue;
    end;

    for j = 1:length(F),
		  % Does factor contain variable?
        indx = find(F(j).var == v);

        if (~isempty(indx)),
        
		  	   % Check validity of evidence
            if (x > F(j).card(indx) || x < 0 ),
                error(['Invalid evidence, X_', int2str(v), ' = ', int2str(x)]);
            end;

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % YOUR CODE HERE
            % Adjust the factor F(j) to account for observed evidence
            % Hint: You might find it helpful to use IndexToAssignment
            %       and SetValueOfAssignment
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            [dummy, mapV] = ismember(v, F(j).var);
            assignments = IndexToAssignment(1:prod(F(j).card),F(j).card);
            bin = zeros(prod(F(j).card),1);
            for k = 1:prod(F(j).card)
                bin(k) = (assignments(k,mapV)==x);
            end
            A = assignments(bin==0,:);
%             A_size = prod(F.card)/(F.card.(mapV));
%             A = [];
%             for k = 1:prod(F.card)
%                 if assignments(k,mapV)==x
%                     A = [A;assignments(k,:)];
%                 end
%             end      
                
            F(j) = SetValueOfAssignment(F(j),A,0);
%             indxX = AssignmentToIndex(assignments(:, mapV), F.card(mapV));
%             for k = 1:prod(F.card)
%                 F.val(k) = (indxX(k)==x)*F.val(k);
%             end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

				% Check validity of evidence / resulting factor
            if (all(F(j).val == 0))
                warning(['Factor ', int2str(j), ' makes variable assignment impossible']);
            end;
        end;
    end;
end;

end
