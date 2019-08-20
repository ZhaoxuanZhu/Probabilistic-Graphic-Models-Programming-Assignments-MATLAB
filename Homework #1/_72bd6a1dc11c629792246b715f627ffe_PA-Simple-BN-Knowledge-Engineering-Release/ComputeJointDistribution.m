%ComputeJointDistribution Computes the joint distribution defined by a set
% of given factors
%
%   Joint = ComputeJointDistribution(F) computes the joint distribution
%   defined by a set of given factors
%
%   Joint is a factor that encapsulates the joint distribution given by F
%   F is a vector of factors (struct array) containing the factors 
%     defining the distribution
%

function Joint = ComputeJointDistribution(F)

  % Check for empty factor list
  if (numel(F) == 0)
      warning('Error: empty factor list');
      Joint = struct('var', [], 'card', [], 'val', []);      
      return;
  end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE:
% Compute the joint distribution defined by F
% You may assume that you are given legal CPDs so no input checking is required.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Joint = struct('var', [], 'card', [], 'val', []); % Returns empty factor. Change this.
for i = 1:length(F)
    if i==1
        Joint = F(i);
    else
        JointP = Joint;
        [dummy, map_existed] = ismember(JointP.var, F(i).var);
        map_existed = map_existed(map_existed~=0);
        var_existed = F(i).var(map_existed);

        Joint.var = union(JointP.var,F(i).var);
        [dummy,map_JP] = ismember(JointP.var,Joint.var);
        [dummy,map_F] = ismember(F(i).var,Joint.var);
        [dummy,map_E] = ismember(var_existed,Joint.var);
        Joint.card = zeros(1, length(Joint.var));
        Joint.card(map_JP) = JointP.card;
        Joint.card(map_F) = F(i).card;
        assignments = IndexToAssignment(1:prod(Joint.card), Joint.card);
        for j=1:prod(Joint.card)
            observe = ObserveEvidence(F(i),[var_existed(:),assignments(j,map_E)']);
            conditional_probability = F(i).val(AssignmentToIndex(assignments(j, map_F), F(i).card))/sum(observe.val);
            Joint.val(j) = JointP.val(AssignmentToIndex(assignments(j,map_JP),JointP.card))*conditional_probability;
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

% function B = FactorReduction(A,V)
%     [dummy,mapV] = ismember(V,A.var);
%     B.var = A.var(A.var~=V);
%     [dummy,mapB] = ismember(B,A.var);
%     B.card = A.card(mapB);
%     
%     for i = 1:prod(B.card)
%         B.val(i) = 
%     end
% end
