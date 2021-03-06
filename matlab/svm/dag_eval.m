% vim: set tabstop=4 shiftwidth=4 :
function [ index ] = dag_eval( x, dag_model )
%DAG_EVAL evaluates multi-class DAG SVM model.
% Args:
%   x: The data point whose category you wish to predict.
%   dag_model: The dag_model trained with dag_train.
% Returns:
%   index: Index in training_categories of the predicted category of x.

num_categories = size(dag_model, 1);

%evaluate x in each of our models, determining what we predict it to be
%tournament style.
i = 1;
j = 2;
for count = 1:num_categories - 2
    model = dag_model{i, j};
    [output, ~, ~] = predict([-1], sparse(x), model);
    %x is not in j'th category
    if output == -1
        j = j + 1;
    %x is not in i'th category
    else
        temp = j;
        j = j + 1;
        i = temp;
    end
end
%we do the last tournament manually, because this gives us our prediction.
model = dag_model{i, j};
[output, ~, ~] = predict([-1], sparse(x), model);
if output == -1
    index = i;
else
    index = j;
end
