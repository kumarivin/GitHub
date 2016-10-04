package com.marketing.Project_Recommend;
import java.sql.Date;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.NavigableSet;
import java.util.PriorityQueue;
import java.util.Properties;
import java.util.Set;
import java.util.TreeMap;

import org.apache.commons.collections.MapUtils;
import org.apache.mahout.cf.taste.common.NoSuchUserException;
import org.apache.mahout.cf.taste.impl.model.file.FileDataModel;
import org.apache.mahout.cf.taste.impl.neighborhood.NearestNUserNeighborhood;
import org.apache.mahout.cf.taste.impl.neighborhood.ThresholdUserNeighborhood;
import org.apache.mahout.cf.taste.impl.recommender.GenericItemBasedRecommender;
import org.apache.mahout.cf.taste.impl.recommender.GenericUserBasedRecommender;
import org.apache.mahout.cf.taste.impl.similarity.PearsonCorrelationSimilarity;
import org.apache.mahout.cf.taste.model.DataModel;
import org.apache.mahout.cf.taste.neighborhood.UserNeighborhood;
import org.apache.mahout.cf.taste.recommender.ItemBasedRecommender;
import org.apache.mahout.cf.taste.recommender.RecommendedItem;
import org.apache.mahout.cf.taste.recommender.Recommender;
import org.apache.mahout.cf.taste.recommender.UserBasedRecommender;
import org.apache.mahout.cf.taste.similarity.ItemSimilarity;
import org.apache.mahout.cf.taste.similarity.UserSimilarity;

import com.google.common.collect.ArrayListMultimap;
import com.google.common.collect.HashBasedTable;
import com.google.common.collect.Iterables;
import com.google.common.collect.ListMultimap;
import com.google.common.collect.Multimap;
import com.google.common.collect.SortedSetMultimap;
import com.google.common.collect.Table;
import com.google.common.collect.TreeMultimap;
import com.google.common.primitives.Ints;

/**
 * Hello world!
 *
 */
public class App7 
{
    private static final int Float = 0;
	private static final int List = 0;
	
	public static void main( String[] args ) throws Exception
    {
    	for (int i=0; i<= 11;i++){
    	String temp ="C:/Users/TG/Documents/Independent study/";    	
    	DataModel model = new FileDataModel(new File(temp+"ratings_train"+Integer.toString(i)+"n.csv"));
    	UserSimilarity similarity = new PearsonCorrelationSimilarity(model);
    	ItemSimilarity isimilarity = new PearsonCorrelationSimilarity(model);
    	//modified
    	UserNeighborhood neighborhood = new NearestNUserNeighborhood(10, similarity, model);
    	UserBasedRecommender recommender = new GenericUserBasedRecommender(model, neighborhood, similarity);
    	/*
        UserNeighborhood neighborhood = new ThresholdUserNeighborhood(0.1, similarity, model);
    	UserBasedRecommender recommender = new GenericUserBasedRecommender(model, neighborhood, similarity);
    	*/
    	ItemBasedRecommender irecommender = new GenericItemBasedRecommender(model,isimilarity);
    	//Code to retreive top movies from training set
    	BufferedReader traindatareader = new BufferedReader(new FileReader(temp+"ratings_train"+Integer.toString(i)+"n.csv"));
    	Multimap<Long,Object> movie_ratings = ArrayListMultimap.create();
    	String line1 = null;
    	
    	while ((line1 = traindatareader.readLine()) != null) {
    		String[] words1 = line1.split(",");
    		if(line1.equals(""))
    			continue;
    		long arg01=Long.parseLong(words1[1]);
    		float arg11=Integer.parseInt(words1[2]);
    		if (movie_ratings.containsKey(arg01)){    			
    			float temp_rating=(java.lang.Float)(Iterables.get(movie_ratings.get((long) arg01),0));
    			temp_rating=(temp_rating+arg11);
    			int temp_count= (Integer) Iterables.get(movie_ratings.get((long) arg01), 1);
    			temp_count=temp_count+1;
    			movie_ratings.removeAll(arg01);
    			movie_ratings.put(arg01, temp_rating);
    			movie_ratings.put(arg01, temp_count);
    			
    		}
    		else{
    			movie_ratings.put(arg01,arg11);
    			movie_ratings.put(arg01,1);
    		}    		
    	}	
    	
    	
    	//Retrieve movies with minimum view ability of 5
    	TreeMultimap<Long,Float> filtered_movie_ratings = TreeMultimap.create();    	
    	for( Long movie:movie_ratings.keySet() ){
    		int temp1=(Integer) Iterables.get(movie_ratings.get((long) movie), 1);
    		if (temp1 > 5){ 
    			float temp2=(java.lang.Float) Iterables.get(movie_ratings.get((long) movie), 0);
    			filtered_movie_ratings.put(movie,(float)temp2/temp1);
    			filtered_movie_ratings.put(movie, (float) temp1);
    		}    		
    		
    	}
    	//Pass the filtered movies for sorting
    	List<Long> top10=topNKeys(filtered_movie_ratings, 10);    	
    	//Read all the test file into a hashmap list for convinience of calculating precision and recall    	
    	BufferedReader reader = new BufferedReader(new FileReader(temp+"ratings_test"+Integer.toString(i)+"n.csv"));
    	Multimap<Long,Object> myMultimap = ArrayListMultimap.create();
    	Table<Long, Long, Float> testTable = HashBasedTable.create();
    	Multimap<Long,Object> User_Prec_rec = ArrayListMultimap.create();
    	long hits=0;
    	long miss=0;
    	String line = null;
    	while ((line = reader.readLine()) != null) {
    		String[] words = line.split(",");
    		if(line.equals(""))
    			continue;
    		long arg0=Long.parseLong(words[0]);
			long arg1=Long.parseLong(words[1]);
			float arg2=Integer.parseInt(words[2]);
			testTable.put(arg0, arg1, arg2);
			//if (arg0==5485){
				//System.out.println(arg0+" "+ arg1+" "+arg2);
				
			//}
    	}
    	reader.close();
    	//System.out.println("print "+(testTable.get((long)5485,(long)588)<3.0));
    	//Retreive all users in test dataset for which we have to calculate precision
    	Set<Long> userlist=testTable.rowKeySet();
    	float total_relevant_items=(float) 0.0;
    	float allhit=(float) 0.0;
    	float totalusers_intrain=(float)0.0;
    	float totalprec=(float)0.0;
    	float totalrecommendations=(float) 0.0;
    	float no_of_users_in_test=userlist.size();
    	for(Long user: userlist){    
    		float prec=0;
    		float rec=0;
    		//Code to retrieved the actual movies that the user under consideration has seen and reviewed
    		totalusers_intrain+=1.0;
    		float userlen=(testTable.row((long)user).keySet().size()); //temp_user.size();
    		
    		float count_hit=0;    		
    		try{			
        	//Code to retrieve recommended movies and ratings for the user under consideration , only top 10
    		java.util.List<RecommendedItem> recommendations = recommender.recommend(user, 10);    
    		
    		if (recommendations.size()>0){    			
    			totalrecommendations+=recommendations.size();
    			total_relevant_items+=userlen;
    			for (RecommendedItem recommendation : recommendations) {
    				
    				//Extract recommended item, verify if it exist in actual data for the given user
    				long recommended_movie = recommendation.getItemID();
    				
                	if (testTable.contains((long)user, (long)recommended_movie) && testTable.get((long)user, (long)recommended_movie)>3.0){                		
                		count_hit+=1;
                		allhit+=1;
                	}                	
                }
    		prec=(float)(count_hit/recommendations.size());
    		totalprec+=prec;
			rec=count_hit/userlen;
			User_Prec_rec.put(user,(float)1.0);
			User_Prec_rec.put(user,prec);
			User_Prec_rec.put(user,rec);
			User_Prec_rec.put(user,count_hit);
			User_Prec_rec.put(user,userlen);
			hits+=1;
    	  }
    		else{
    			Iterator<Long> topmv = top10.iterator();
    			totalrecommendations+=10;  
    			total_relevant_items+=userlen;  							
				while (topmv.hasNext()) {
    				//Extract recommended item, verify if it exist in actual data for the given user
    				long mv= topmv.next();
                	if (testTable.contains((long)user,(long)mv) && testTable.get((long)user,(long)mv)>3.0){
                		count_hit+=1;
                		allhit+=1;
                	}                	
                }
    		prec=count_hit/10;
    		totalprec+=prec;
			rec=count_hit/userlen;
			User_Prec_rec.put(user,(float)0.0);
			User_Prec_rec.put(user,prec);
			User_Prec_rec.put(user,rec);
			User_Prec_rec.put(user,count_hit);
			User_Prec_rec.put(user,userlen);    			
			miss+=1;  
    		}
    	}	
    		catch(NoSuchUserException e){ 
    			System.out.println("test");    				 			
    		}  		
    	}
    	float total_precision= allhit/(totalrecommendations); 
    	//totalprec/totalusers_intrain;
    	float total_recall=allhit/(total_relevant_items);
    	try
    	{
    	    String filename= "Data/precrec10_1.txt";
    	    FileWriter fw = new FileWriter(filename,true); //the true will append the new data
    	    fw.write("epoch :"+Integer.toString(i)+'\n');
    	    fw.write("hits: "+ Long.toString(hits)+ " miss: "+Long.toString(miss)+ " total relevant items in recommendations: "+Long.toString((long) allhit)+" total recommendations: "+Long.toString((long) totalrecommendations)+ " total relevant items: "+Long.toString((long) total_relevant_items)+'\n');
    	    fw.write(User_Prec_rec.toString()+'\n');  
    	    fw.write("Total Precision: "+ (total_precision)+ " Total recall: "+(total_recall)+'\n');
    	    fw.close();
    	}
    	catch(IOException ioe){
    	    System.err.println("IOException: " + ioe.getMessage());
    	}    	
    }
   }  
	public static List<Long> topNKeys(final TreeMultimap<Long, Float> map, int n) {
	    PriorityQueue<Long> topN = new PriorityQueue<Long>(n, new Comparator<Long>() {
	        public int compare(Long o1, Long o2) {
	        	float o1r=(java.lang.Float) Iterables.get(map.get((long) o1), 0);
	        	float o2r=(java.lang.Float) Iterables.get(map.get((long) o2), 0);
	        	return Double.compare(o1r, o2r);
			}
	    });

	    for(Long key:map.keySet()){
	        if (topN.size() < n)
	            topN.add(key); 	        
	        
	        else if (Iterables.get(map.get((long) topN.peek()), 0)< Iterables.get(map.get((long) key), 0)) {
	            topN.poll();
	            topN.add(key);
	        }
	    }
	    return (List) Arrays.asList(topN.toArray());
	}

}
