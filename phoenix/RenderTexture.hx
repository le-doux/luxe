package phoenix;

import lime.gl.GLFramebuffer;
import phoenix.Batcher;
import phoenix.Resource;
import phoenix.ResourceManager;
import phoenix.Texture;

import lime.gl.GL;

	//A render texture just extends texture so it can be assigned to meshes etc
class RenderTexture extends Texture {

	public var fbo : GLFramebuffer;

	public function new( _manager:ResourceManager, ?_size:Vector = null ) {

		super( _manager, ResourceType.render_texture );

			//Set it to the buffer
		_size == null ? new Vector( Luxe.screen.w, Luxe.screen.h ) : _size ;
			//Width and height of this texture item
		width = actual_width = Std.int(_size.x);
		height = actual_height = Std.int(_size.y);

			//Create the render texture for the fbo
		texture = GL.createTexture();
			//Bind the texture 
		bind();
			//Create the actual texture in memory
		GL.texImage2D( GL.TEXTURE_2D, 0, GL.RGBA, width, height, 0, GL.RGBA, GL.UNSIGNED_BYTE, null );
			//these must be set to be texture complete
		_set_filter(phoenix.FilterType.linear);
		_set_clamp(phoenix.ClampType.edge);

			//Create the FBO
		fbo = GL.createFramebuffer();
			//Bind the FBO
		bindBuffer();
			//Attach the framebuffer texture to the buffer
		GL.framebufferTexture2D( GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0, GL.TEXTURE_2D, texture, 0 );

		var status = GL.checkFramebufferStatus( GL.FRAMEBUFFER );
		switch (status) {
	        case GL.FRAMEBUFFER_COMPLETE:
	            
	        case GL.FRAMEBUFFER_INCOMPLETE_ATTACHMENT:
	            throw("Incomplete framebuffer: FRAMEBUFFER_INCOMPLETE_ATTACHMENT");
	            
	        case GL.FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT:
	            throw("Incomplete framebuffer: FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT");
	            
	        case GL.FRAMEBUFFER_INCOMPLETE_DIMENSIONS:
	            throw("Incomplete framebuffer: FRAMEBUFFER_INCOMPLETE_DIMENSIONS");
	            
	        case GL.FRAMEBUFFER_UNSUPPORTED:
	            throw("Incomplete framebuffer: FRAMEBUFFER_UNSUPPORTED");
	            
	        default:
	            throw("Incomplete framebuffer: " + status);
	    }

			//No lingering
		unbindBuffer();

		loaded = true;

		trace(this);

	} //new

	public override function destroy() {

		GL.deleteFramebuffer( fbo );

		super.destroy();
	} //destroy

	public function bindBuffer() {
		GL.bindFramebuffer( GL.FRAMEBUFFER, fbo );
	} //bind

	public function unbindBuffer( ?_other:GLFramebuffer=null ) {

			//defaults to null, which is the normal framebuffer
		GL.bindFramebuffer( GL.FRAMEBUFFER, _other );
		
	} //unbind


} //RenderTexture