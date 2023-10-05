
function Iba1CD68 (input, Iba1, CD68, filename){
	open (input + filename);
	Stack.getDimensions(width, height, channels, slices, frames);

	for (i=1; i<frames+1; i++){
		run("Make Substack...", "channels=1-3 slices=1-"+slices + " frames=" + i); //split the ith position

		newname=getTitle; //get the name of the image
		dashIndex= indexOf (newname, "-");
		animalnumber= substring (newname, 0, dashIndex);
		
		selectWindow(newname); //position 1 image
		run("Duplicate...", "title=dup duplicate"); //Duplicate position i "dup"
		
		selectWindow(newname);
		run("Subtract Background...", "rolling=50 stack"); //Subtract background
		run("Split Channels"); //Split the channels
		selectWindow("C1-"+newname); //Close the DAPI
		close();
		
		selectWindow("dup"); //Split the channels from the duplicated image
		run("Split Channels");
		
		selectWindow("C1-dup"); //Close the DAPI duplicated image
		close();
		
		//Iba1 threshold
		selectWindow("C3-"+newname);
		setThreshold(34, 255);
		setOption("BlackBackground", false);
		run("Convert to Mask", "method=Default background=Light");
		
		//CD68 threshold
		selectWindow("C2-"+newname);
		setThreshold(32, 255);
		setOption("BlackBackground", false);
		run("Convert to Mask", "method=Default background=Light");
		
		//iba1 analysis
		run("Set Measurements...", "area mean min integrated redirect=C3-dup decimal=3");
		selectWindow("C3-"+newname);
		run("Analyze Particles...", "size=0.2-Infinity show=[Bare Outlines] display clear stack");
		saveAs ("Results",Iba1+animalnumber+"-"+i+".csv");
		
		//cd68 analysis
		run("Set Measurements...", "area mean min integrated redirect=C2-dup decimal=3");
		selectWindow("C2-"+newname);
		run("Analyze Particles...", "size=0.20-Infinity show=[Bare Outlines] display clear stack");
		saveAs ("Results",CD68+animalnumber+"-"+i+".csv");
		
		run("Close All");
		open(input + filename);
	}
	close(input+filename);
	
}


input= "/Users/paula/Desktop/11-1-16 Iba1 CD68 NPC PLX/11-4-16 Iba1 CD68 NPC/";
Iba1= "/Users/paula/Desktop/11-1-16 Iba1 CD68 NPC PLX/Iba1";
CD68= "/Users/paula/Desktop/11-1-16 Iba1 CD68 NPC PLX/CD68"; 
list= getFileList (input);


for (i=0; i < list.length; i++)
	Iba1CD68(input, Iba1, CD68, list[i]);



