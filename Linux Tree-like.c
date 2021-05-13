#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <dirent.h>
#include <errno.h>
#include <string.h>
#include <stdlib.h>
#include <pwd.h>
#include <grp.h>

#define BASE_LOCATION "."
#define PRINT_SIGN " "
#define FIRST_PRINT_SIGN "|"
#define ALLOCATION_ADDON 2
#define ALLOCATION_MULTIPLIER 2
#define PRINT_SIGNS_MULTIPLIER 2-1

void GetMyType(char type){
    switch (type){
		case DT_BLK:
			printf("b");
			return;
		case DT_CHR:
			printf("c");
			return;
		case DT_DIR:
			printf("d");
			return;
		case DT_FIFO:
			printf("p");
			return;
		case DT_LNK:
			printf("l");
			return;
		case DT_REG:
			printf("-");
			return;
		case DT_SOCK:
			printf("s");
			return;
	}
}

void GetMyUserName(uid_t user){
	struct passwd *pws;
    pws = getpwuid(user);
    printf("%s ", pws->pw_name);
}

void GetMyGroup(uid_t group){
	struct group *pws;
    pws = getgrgid(group);
    printf("%s ", pws->gr_name);
}

//Prints permission of the file
void GetMyPermission(mode_t *file){
    char *permissions = malloc(sizeof(char) * 9 + 1);
    permissions[0] = (*file & S_IRUSR) ? 'r' : '-';
    permissions[1] = (*file & S_IWUSR) ? 'w' : '-';
    permissions[2] = (*file & S_IXUSR) ? 'x' : '-';
    permissions[3] = (*file & S_IRGRP) ? 'r' : '-';
    permissions[4] = (*file & S_IWGRP) ? 'w' : '-';
    permissions[5] = (*file & S_IXGRP) ? 'x' : '-';
    permissions[6] = (*file & S_IROTH) ? 'r' : '-';
    permissions[7] = (*file & S_IWOTH) ? 'w' : '-';
    permissions[8] = (*file & S_IXOTH) ? 'x' : '-';
    permissions[9] = '\0';
	printf("%s ", permissions);
	free(permissions);    
}
void CheckAndRealloc(char** char_string, int* max_length, int filename_length, int base_location){
	while (*max_length <= base_location + filename_length + ALLOCATION_ADDON){
		*max_length*=ALLOCATION_MULTIPLIER;
		*char_string = (char*)realloc(*char_string, *max_length * sizeof(char));
	}
}

//Builds whole file path for stat
char* BuildNewLocation(char* previous_location, char* directory, char* write_char, int* max_length){
	write_char[0] = '\0';
	strcat(write_char, previous_location);
	strcat(write_char, "/");
	strcat(write_char, directory);
	return write_char;
}

void PrintMySigns(int count){
	printf(FIRST_PRINT_SIGN);
	for (int i=0;i<count*PRINT_SIGNS_MULTIPLIER;i++){
		printf(PRINT_SIGN);
	}
}

//When using for the first time use recurrension_depth = 1
void ListMyCatalog(char* basic_location, int recurrension_depth){
	DIR *pDIR;
	struct dirent *pDirEnt;
	struct stat file_stats;
	pDIR = opendir(basic_location);
	if (pDIR == NULL){
		fprintf(stderr, "%s %d: opendir() failed (%s)\n", __FILE__,__LINE__, strerror(errno));
		recurrension_depth--;
		return;
	}
	pDirEnt = readdir(pDIR);
	int max_file_length = strlen(basic_location) + ALLOCATION_ADDON;
	char* new_location = (char*)malloc(max_file_length*sizeof(char));
	while (pDirEnt!=NULL){
		if (!strcmp(pDirEnt->d_name, "..") || !strcmp(pDirEnt->d_name, ".")){
			pDirEnt = readdir(pDIR);
			continue;
		}
		PrintMySigns(recurrension_depth);
		CheckAndRealloc(&new_location, &max_file_length, strlen(pDirEnt->d_name), strlen(basic_location));
		BuildNewLocation(basic_location, pDirEnt->d_name, new_location, &max_file_length);
		if (!stat(new_location, &file_stats)){
                //FORMAT: TYP PRAWA DOSTĘPU USER GROUP ROZMIAR NAZWA
				GetMyType(pDirEnt->d_type);
				GetMyPermission(&file_stats.st_mode);
				GetMyUserName(file_stats.st_uid);
				GetMyGroup(file_stats.st_gid);
				printf("%u bytes ", (unsigned int)file_stats.st_size);
				printf("%s\n", pDirEnt->d_name);
            }
        else{
               printf("(stat() failed for this file)\n");
           }
		if (pDirEnt->d_type == DT_DIR && (strcmp(pDirEnt->d_name, "..") && strcmp(pDirEnt->d_name, "."))){
			ListMyCatalog(new_location, recurrension_depth+1);	
		}
		pDirEnt = readdir(pDIR);
	}
	closedir(pDIR);
	free(new_location);
}

int main(int argc, char* argv[]){
	ListMyCatalog(BASE_LOCATION, 1);
	return 0;
}
