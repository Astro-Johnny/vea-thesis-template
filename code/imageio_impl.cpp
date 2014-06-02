/* imageio_impl.cpp
 * Implementation of imageio package foreign subprograms in C++
 * 
 * authors:
 * Jânis "Johny" Ðmçdiòð, ©2014      Jânis "Johny" Ðmçdiòð
 */

#include <vector>
#include <exception>
#include <string>
#include <cvd/image_io.h>


/*** PRIVATE TYPES *****************************************************/
namespace { /* private namespace */
	struct _ghdl_bounds
	{
		int left;
		int right;
		char dir;
		unsigned int len;
	};

	struct _ghdl_string
	{
		char *base;
		struct _ghdl_bounds* bound;
	};
}; /* end of private namespace */


/*** PRIVATE STATIC VARIABLES ("GLOBALS") ******************************/
namespace { /* private namespace */
	static std::vector<CVD::Image<CVD::byte>*> img_set;
}; /* end of private namespace */


/*** PUBLIC FUNCTION DEFINITIONS ***************************************/
extern "C" {
	int _imageio_open_image(const struct _ghdl_string *str)
	{
		int i;
		CVD::Image<CVD::byte>* img = 0;
		
		/* Open the image */
		try
		{
			std::string pathname(str->base, str->base + str->bound->len);
			
			img = new CVD::Image<CVD::byte>;
			*img = CVD::img_load(pathname);
		}
		catch (...)
		{
			delete img;
			return -1;
		}
		
		/* Find a unused image slot */
		for (i=0; i<img_set.size(); i++)
		{
			if (img_set[i]==0)
			{
				img_set[i] = img;
				return i;
			}
		}
		try
		{
			img_set.push_back(img);
		}
		catch (...)
		{
			delete img;
			return -1;
		}
		return i;
	}
	
	int _imageio_get_pixel(int i, int x, int y)
	{
		return (int)((*img_set[i])[y][x]);
	}
} /* end of extern "C" */
