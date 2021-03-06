#' Select active areas within a mask
#'
#' Select the part of the image within the mask. 
#'
#' @param mask path of the mask file
#' @param img path of the image file
#'
#' @return A list with the following elements
#' \describe{
#'   \item{array}{array containing voxels within the mask}
#'   \item{original_coord}{coordinates of the limits of the mask with respect to the original size of the image}
#' }
#'
#' @author Marco Palma, \email{M.Palma@@warwick.ac.uk}
#' @keywords resize_image
#'
#' @export


resize_image <- function(mask, img = mask){
  mask <- drop(mask)
  img <- drop(img)
  dims <- dim(mask)

  if(!all.equal(dim(img), dims)) stop("Mask and img must have the same dimensions!")

  nonzero_coord <- matrix(NA, nrow = length(dims), ncol = 2)
  rownames(nonzero_coord) <- paste0("Dim", 1:length(dims))
  colnames(nonzero_coord) <- c("first","last")


  for(i in 1:length(dims)) nonzero_coord[i,] <- range(which(apply(mask,i,sum) != 0))
  ###select first and last coordinate for which the sum is non zero

  resized_array <- (img[,,] * (mask[,,]>0))[nonzero_coord[1,"first"]:nonzero_coord[1,"last"],
                                            nonzero_coord[2,"first"]:nonzero_coord[2,"last"],
                                            nonzero_coord[3,"first"]:nonzero_coord[3,"last"]]

  list(array = resized_array, original_coord = nonzero_coord)
}
