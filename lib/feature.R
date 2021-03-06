################################################################
### We will use COLOR to extract the features for the images ###
################################################################

### Authors: Xiuruo Yan
### Project 3
### ADS Spring 2017



feature <- function(img_dir, run.sift_pca = F, run.gray = F, 
                    run.hogs = F, run.color = F, export = T){
  
  ## run COLOR feature extraction
  #color features
  #load library

  if(run.color){
    
    library("EBImage")
    
    img_names<-list.files("img_dir")
    Rbin<-seq(0,1,length.out =  10) 
    Gbin<-seq(0,1,length.out = 10)
    Bbin<-seq(0,1,length.out = 10)
    
    Hbin<-seq(0,1,length.out =  10) 
    Sbin<-seq(0,1,length.out = 10)
    Vbin<-seq(0,0.005,length.out = 10)
    
    
    ##RGB features
    rgb_features<-data.frame(matrix(NA,length(img_names),1001))
    colnames(rgb_features)<-c('Image',paste('rbg_',1:1000,sep=""))
    rgb_features$Image<-img_names
    
    hsv_features<-data.frame(matrix(NA,length(img_names),1001))
    colnames(hsv_features)<-c('Image',paste('hsv_',1:1000,sep=""))
    hsv_features$Image<-img_names
    
    
    for(i in 1:length(img_names)){
      print(i)
      img<-readImage(paste("data/image/images/",img_names[i],sep=""))
      if(length(dim(img))!=3){
        next
      }
      img<-resize(img,256,256)
      img_mat<-imageData(img)
      
      ### RGB
      rgb_mat<-img_mat
      rgb_df=as.data.frame(table(factor(findInterval(rgb_mat[,,1],Rbin),levels = 1:10),
                                 factor(findInterval(rgb_mat[,,2],Gbin),levels = 1:10),
                                 factor(findInterval(rgb_mat[,,3],Bbin),levels = 1:10)))
      rgb_features[i,2:1001]<-rgb_df$Freq/(256^2)
      
      ### HSV
      dim(img_mat)<-c(256*256,3)
      hsv_mat<-rgb2hsv(t(img_mat))
      hsv_df=as.data.frame(table(factor(findInterval(hsv_mat[1,],Hbin),levels = 1:10),
                                 factor(findInterval(hsv_mat[2,],Sbin),levels = 1:10),
                                 factor(findInterval(hsv_mat[3,],Vbin),levels = 1:10)))
      hsv_features[i,2:1001]<-hsv_df$Freq/(256^2)
    }
    
    color_features<-merge(rgb_features,hsv_features,by.x = "Image",by.y="Image")
    write.csv(color_features,"../output/color_features.csv",row.names = F)
    
    return(color_features)
  }
  
  
  ## run PCA on sift features
  H <- NULL
  pcaFeatures <- NULL
  if(run.pca){
   pcaFeatures <- pcaFeatureExtraction(H, desired_variance)
   save(pcaFeatures, file=paste0("../output/sift_pca.RData"))
   return(sift_pca)
 }

## run GRAY feature extraction
 grayFeatures <- NULL
 if( run.cnn ){
   cnnFeatures <- cnnFeatureExtraction(img_dir)
   save(grayFeatures, file=paste0("../output/grayFeatures.RData"))
   return( grayFeatures )
 }
 
 ## run HOG feature extraction
 hogsFeatures <- NULL
 if( run.hogs ){
   hogsFeatures <- hogsFeatureExtraction()
   save(hogsFeatures, file=paste0("../output/hogsFeatures.RData"))
   return( hogsFeatures )
 }

}