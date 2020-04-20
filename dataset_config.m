%��� �� �������� ����� � ������� ��� Matlab ���������� �� ����� load u.data
%��� �� ���������� ��� �� �������� ascendingly ���� �� user_id ��� �� 
%movie_id

user_id = u(:,1);
movie_id = u(:,2);
rating = u(:,3);
timestamps = u(:,4);
avg_init_rating= mean(rating); %����� ���� ��� �� ������� �� ��� �������� �����
%����������� ��� vectors ��� �������� �� ����� ���� ������������� ������
total_number_of_ratings= zeros(1682*943,1);
total_movie_ids= zeros(1682*943,1);
total_ratings= zeros(1682*943,1);
k=0;
%����������� vectors
for i = 1:943
    for j= 1:1682
    total_number_of_ratings(j+k)= i;
    total_movie_ids(j+k)= j;
    end
    k= i*1682;
end

user_initiative=0;
size(movie_id,1);
size(total_ratings,1);
count=1;
%�������� ������� ratings ���� ������ ������
for i = 1 : size(movie_id,1)-1
    total_ratings(user_initiative*1682 + movie_id(i))= rating(i);
    if(movie_id(i) > movie_id(i+1) )
        user_initiative= user_initiative+1;
    else if (i== size(movie_id,1)-1)
       total_ratings(user_initiative*1682 + movie_id(i+1))= rating(i+1);     
        end
    end
end
total_ratings= rescale(total_ratings);
total_ratings;
size(total_ratings,1);
count=0;
%���������� ������ ������� �� �� �� ���� ��� ������� �� ��� �������� �����
filled_data=[total_number_of_ratings(:),total_movie_ids(:),total_ratings(:)];
%data = num2cell(filled_data);
%filled_data = cell2mat(data);
c=100;

avgs = zeros(943,1);
sum=0;
inner_count=0;
%���������� vector �� ���� ������ ������ ���� ������ ��� �����������
for i= 1: size(user_id,1)-1
     sum = sum + rating(i);
     count = count+1;
     if(movie_id(i) > movie_id(i+1))
       inner_count = inner_count +1;
       avgs(inner_count) = sum/count;
       sum=0;
       count=0;
     else if (i== size(user_id,1)-1)
       inner_count = inner_count +1;
       avgs(inner_count) = sum/count;
       sum=0;
       count=0;
        %sum = sum + rating(i);     
     end
     end
end
avgs;
inner_count=1;
%�������� ��� ����� ���� ��� ���� ������������ �������
for i= 1: size(user_id,1)-1
    rating(i)= rating(i) - avgs(inner_count);
    if(movie_id(i) > movie_id(i+1))
       inner_count = inner_count +1;
    end
    if (i== size(movie_id,1)-1)
        rating(i+1)= rating(i+1) - avgs(inner_count);
    end
    
end
%mapping ��� ����� ��� [0,1] ��� �� ����� ������� �� ��� ���������
%���������
rating=rescale(rating);
centralized_data = [user_id(:),movie_id(:),rating(:), timestamps(:)];
data= num2cell(centralized_data);
centralized_data = cell2mat(data);
%�������������� ���������
normalized_centralized_Data = rating/norm(rating);
reformed_normalized_centralized_data=[user_id(:),movie_id(:),normalized_centralized_Data(:), timestamps(:)];


%%%%%%% ������� ��������� �� txt ��� �� �� ������������ � Weka �� �����
%%%%%%% arff%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%[fid,msg] = fopen('actual_dataset.txt','wt');
%assert(fid>=3,msg)
%fprintf(fid,'%d\t %d\t %f\n',filled_data.');
%fclose(fid);
            