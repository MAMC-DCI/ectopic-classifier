# Prepare project directory

# Create Cache and Results directories.
directories <- c("Cache","Results")

for(i in directories){
  if(dir.exists(i)){
    unlink(i, recursive = TRUE)
  }
  dir.create(i)
}
