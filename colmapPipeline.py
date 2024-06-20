'''
Python script to run colmap on compute canada cedar cluster. Needs command line arguments for image folder path and optional command line arguments for sparse reconstruction input path.
'''

# Imports
import subprocess
import argparse
import pathlib
import pycolmap

if __name__ == '__main__':
    #help(pycolmap.SiftExtractionOptions)
    #print(pycolmap.SiftExtractionOptions().summary())
    # Get path to image files from command line arguments
    # Can pass multiple paths to image folders
    parser = argparse.ArgumentParser(
        description="Path to images folder(s), optional path to sparse reconstruction inputs ")

    # Add parser argument for input images paths 
    parser.add_argument('images', type=pathlib.Path, help='Path for images directory')

    # Add parser argument for output path
    parser.add_argument('output', type=pathlib.Path, help='Path for output')

    # Get path to sparse reconstruction inputs (optional)
    #parser.add_argument('sparse_inputs', type=Path, nargs='*',
                        #help='Path to sparse reconstruction input folder(s) - optional argument')

    # Grab command line arguments
    args = parser.parse_args()
    current_directory = pathlib.Path.cwd()
    #current_directory.chmod(33206)

    # Assign image folders arguments
    image_dir: pathlib.Path
    image_dir = args.images
    #image_dir.chmod(33206)

    # Assign output path
    output_path : pathlib.Path
    output_path = args.output
    #output_path.chmod(33206)
    
  

    # Creating database and mvs paths
    #output_path.mkdir()
    mvs_path = output_path / "mvs"
   
    
    database_path = output_path / "database.db"
   

    

    pycolmap.extract_features(database_path, image_dir)
    
    #Stop here?
     
     
    pycolmap.match_exhaustive(database_path)
    
    
    maps = pycolmap.incremental_mapping(database_path, image_dir, output_path)
    maps[0].write(output_path)
    
    

    
    
    pycolmap.undistort_images(mvs_path, output_path, image_dir)
    #mvs_path.chmod(33206)
    
    
    # Stop here
    pycolmap.patch_match_stereo(mvs_path)  # requires compilation with CUDA
    pycolmap.stereo_fusion(mvs_path / "dense.ply", mvs_path)

   
