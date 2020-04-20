%Για να δουλεψει σωστα ο κωδικας της Matlab χρειαζεται να γινει load u.data
%και να διαταχθουν ολα τα στοιχεια ascendingly κατα το user_id και το 
%movie_id

user_id = u(:,1);
movie_id = u(:,2);
rating = u(:,3);
timestamps = u(:,4);
avg_init_rating= mean(rating); %Μεσος ορος για το ερωτημα με τις ελλιπεις τιμες
%δημιουργεια των vectors που αργοτερα θα μπουν στον τελειωποιμενο πινακα
total_number_of_ratings= zeros(1682*943,1);
total_movie_ids= zeros(1682*943,1);
total_ratings= zeros(1682*943,1);
k=0;
%αρχικοποηση vectors
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
%Διασπορα αρχικων ratings στις σωστες θεσεις
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
%δημιουργια πινακα αναλογα με το τι ζητα στο ερωτημα μρ τις ελειπεις τιμες
filled_data=[total_number_of_ratings(:),total_movie_ids(:),total_ratings(:)];
%data = num2cell(filled_data);
%filled_data = cell2mat(data);
c=100;

avgs = zeros(943,1);
sum=0;
inner_count=0;
%δημιουργια vector με τους μεσους οροους καθε χρηστη για κεντραρισμα
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
%αφαιρεση του μεσου ορου απο τους αντιστοιχους χρηστες
for i= 1: size(user_id,1)-1
    rating(i)= rating(i) - avgs(inner_count);
    if(movie_id(i) > movie_id(i+1))
       inner_count = inner_count +1;
    end
    if (i== size(movie_id,1)-1)
        rating(i+1)= rating(i+1) - avgs(inner_count);
    end
    
end
%mapping των τιμων στο [0,1] για να ειναι συμβατα με την λογιστικη
%συναρτηση
rating=rescale(rating);
centralized_data = [user_id(:),movie_id(:),rating(:), timestamps(:)];
data= num2cell(centralized_data);
centralized_data = cell2mat(data);
%κανονικοποιηση δεδομενων
normalized_centralized_Data = rating/norm(rating);
reformed_normalized_centralized_data=[user_id(:),movie_id(:),normalized_centralized_Data(:), timestamps(:)];


%%%%%%% εξαγωγη δεδομενων σε txt για να τα επεξεργαστει η Weka σε μορφη
%%%%%%% arff%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%[fid,msg] = fopen('actual_dataset.txt','wt');
%assert(fid>=3,msg)
%fprintf(fid,'%d\t %d\t %f\n',filled_data.');
%fclose(fid);
            