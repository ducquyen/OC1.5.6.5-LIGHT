<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<title><?php echo $title; ?></title>
<base href="<?php echo $base; ?>" />
<link type="text/css" href="view/stylesheet/filemanager.css" rel="stylesheet" />
<link type="text/css" href="view/javascript/plupload/js/jquery.ui.plupload/css/jquery.ui.plupload.css" rel="stylesheet" />
<link type="text/css" href="view/javascript/jquery/ui/themes/ui-lightness/jquery-ui-1.8.16.custom.css" rel="stylesheet" />

<script type="text/javascript" src="view/javascript/jquery/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="view/javascript/jquery/ui/jquery-ui-1.8.16.custom.min.js"></script>
<script type="text/javascript" src="view/javascript/jquery/ui/external/jquery.bgiframe-2.1.2.js"></script>
<script type="text/javascript" src="view/javascript/jquery/jstree/jquery.tree.min.js"></script>
<script type="text/javascript" src="view/javascript/jquery/jstree/lib/jquery.cookie.js"></script>
<script type="text/javascript" src="view/javascript/jquery/jstree/plugins/jquery.tree.cookie.js"></script>
<script type="text/javascript" src="view/javascript/plupload/js/plupload.full.min.js"></script>
<script type="text/javascript" src="view/javascript/plupload/js/jquery.ui.plupload/jquery.ui.plupload.js"></script>
<script type="text/javascript" src="view/javascript/jquery/ajaxupload.js"></script>
</head>
<body>
<div id="container">
  <div id="file-menu">
    <a id="create" class="filemanager-button" style="background-image: url('view/image/filemanager/folder.png');"><?php echo $button_folder; ?></a>
    <a id="delete" class="filemanager-button" style="background-image: url('view/image/filemanager/edit-delete.png');"><?php echo $button_delete; ?></a>
    <a id="move" class="filemanager-button" style="background-image: url('view/image/filemanager/edit-cut.png');"><?php echo $button_move; ?></a>
    <a id="copy" class="filemanager-button" style="background-image: url('view/image/filemanager/edit-copy.png');"><?php echo $button_copy; ?></a>
    <a id="rename" class="filemanager-button" style="background-image: url('view/image/filemanager/edit-rename.png');"><?php echo $button_rename; ?></a>
    <a id="upload" class="filemanager-button" style="background-image: url('view/image/filemanager/upload.png');"><?php echo $button_upload; ?></a>
    <a id="uploadmulti" class="filemanager-button" style="background-image: url('view/image/filemanager/upload-plus.png');"><?php echo $button_uploads; ?>+</a>
    <a id="refresh" class="filemanager-button" style="background-image: url('view/image/filemanager/refresh.png');"><?php echo $button_refresh; ?></a>
  </div>
  <div id="column-right"></div>
  <div id="column-left"></div>
  <div class="filter">
    <input type="text" name="filter" id="filter" /><img src="view/image/filemanager/filter.png" alt="" />
  </div>
  <div id="toolset">
    <button id="btnExpand" class="btn"><?php echo $button_expand; ?></button>
    <button id="btnCollapse" class="btn"><?php echo $button_collapse; ?></button>
    <button id="btnTextView" class="btn"><?php echo $button_view_text; ?></button>
    <button id="btnListView" class="btn"><?php echo $button_view_list; ?></button>
    <button id="btnThumbView" class="btn"><?php echo $button_view_thumb; ?></button>
  </div>
  <span style="float:right; font-size:12px; padding:10px 10px 0px 0px; color:#269BC6;">
    <a onclick="window.open('http://villagedefrance.net');" title="villagedefrance" style="text-decoration:none;">Overclocked Edition</a>
  </span>
</div>

<script type="text/javascript"><!--
$(document).ready(function() {
	$('#column-left').tree({
		plugins: {
			cookie: {}
		},
		data: {
			type: 'json',
			async: true,
			opts: {
				method: 'post',
				url: 'index.php?route=common/filemanager/directory&token=<?php echo $token; ?>'
			}
		},
		selected: 'top',
		opened: ['top'],
		ui: {
			theme_name: 'apple',
			animation: 60
		},
		types: {
			'default': {
				clickable: true,
				creatable: false,
				renameable: false,
				deletable: false,
				draggable: false,
				max_children: -1,
				max_depth: -1,
				valid_children: 'all'
			}
		},
		callback: {
			beforedata: function(NODE, TREE_OBJ) {
				if (NODE == false) {
					TREE_OBJ.settings.data.opts.static = [{
						data: 'image',
						attributes: {
							'id': 'top',
							'directory': ''
						},
						state: 'closed'
					}];
					return {'directory': ''}
				} else {
					TREE_OBJ.settings.data.opts.static = false;
					return {'directory': $(NODE).attr('directory')}
				}
			},
			onselect: function(NODE, TREE_OBJ) {
				var dr;
				var tree = $.tree.focused('#column-left a');
				window.dr = $(tree.selected).attr('directory');
				$.ajax({
					url: 'index.php?route=common/filemanager/files&token=<?php echo $token; ?>',
					type: 'post',
					data: 'directory=' + encodeURIComponent($(NODE).attr('directory')),
					dataType: 'json',
					success: function(json) {
						html = '<div>';
						if (json) {
							if (json.length == 0) {
								html += '<div class="feedback"><?php echo $text_no_file_found; ?></div>';
							} else {
								for (i = 0; i < json.length; i++) {
									html += '<a file="' + json[i]['file'] + '" style="display:none; float:left;" title="' + json[i]['filename'] + '"><span class="fileName">' + ((json[i]['filename'].length > 16) ? (json[i]['filename'].substr(0, 16) + '..') : json[i]['filename']) + '</span><span class="fileSize">' + json[i]['size'] + '</span><input type="hidden" name="image" value="' + json[i]['file'] + '" /></a>';
								}
							}
						}
						html += '</div>';

						$('#column-right').html(html);

						$('#column-right a').each(function(index, element) {
							$.ajax({
								url: 'index.php?route=common/filemanager/image&token=<?php echo $token; ?>&image=' + encodeURIComponent('data/' + $(element).find('input[name=\'image\']').attr('value')),
								dataType: 'html',
								success: function(html) {
									$(element).prepend('<img src="' + html + '" title="" alt="" /><br />');
									$(element).fadeIn(60);
								}
							});
						});
					},
					error: function(xhr, ajaxOptions, thrownError) {
						alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
					}
				});
			},
			onopen: function(NODE, TREE_OBJ) {
				var tr = $('#column-left li#top li[directory]');

				tr.each(function(index, domEle) {
					dd = $(domEle).attr('directory');
					dd = dd.replace(/\//g, "");
					dd = dd.replace(" ", "");
					$(domEle).attr('id', dd);
				});

				var memTree = $.tree.focused('#column-left a');
				var cc = $.cookie('selected');
				var bb = '#' + cc;

				memTree.select_branch(bb);
			}
		}
	});

	$('#column-right a').live('click', function() {
		if ($(this).attr('class') == 'selected') {
			$(this).removeAttr('class');
		} else {
			$('#column-right a').removeAttr('class');
			$(this).attr('class', 'selected');
		}
	});

	$('#column-right a').live('dblclick', function() {
		<?php if ($fckeditor) { ?>
			window.opener.CKEDITOR.tools.callFunction(<?php echo $fckeditor; ?>, '<?php echo $directory; ?>' + $(this).find('input[name=\'image\']').attr('value'));
			self.close();
		<?php } else { ?>
			parent.$('#<?php echo $field; ?>').attr('value', 'data/' + $(this).find('input[name=\'image\']').attr('value'));
			parent.$('#dialog').dialog('close');
			parent.$('#dialog').remove();
		<?php } ?>
	});

	$('#toolset button:first').button({
        icons: {primary: 'ui-icon-plus'}
	}).next().button({
		icons: {primary: 'ui-icon-minus'}
	}).next().button({
		icons: {primary: 'ui-icon-pencil'}
	}).next().button({
		icons: {primary: 'ui-icon-grip-dotted-horizontal'}
	}).next().button({
		icons: {primary: 'ui-icon-image'}
	});

	$('#btnExpand').click(function() {
		var allTree= $.tree.focused();
        allTree.open_all('#top');
		allTree.refresh(allTree);
	});

	$('#btnCollapse').click(function() {
		var allTree= $.tree.focused();
        allTree.close_all('#top');
		allTree.refresh(allTree);
	});

	$('#btnTextView').click(function() {
		$('#column-right a img').hide();
		$('#column-right a').each(function(index, e2) {
			$('span.fileSize').hide();
			$(e2).css({
				'width': '30%',
				'height': '20px',
				'padding': '0',
				'float': 'left',
				'text-align': 'left'
			});
			$('span.fileName').css({
				'margin-top': '-10px',
				'margin-left': '15px',
				'text-decoration': 'none'
			});
		});
	});

	$('#btnListView').click(function() {
		$('#column-right a img').show();
		$('#column-right a img').each(function(index, e1) {
			$(e1).css({
				'width': '35px',
				'height': '35px',
				'float': 'left',
				'padding': '3px',
				'text-align': 'center'
			});
		});

		$('#column-right a').each(function(index, e2) {
			$('span.fileSize').hide();
			$(e2).css({
				'width': '30%',
				'height': '40px',
				'padding': '0',
				'float': 'left',
				'text-align': 'center'
			});
			$('span.fileName').css({
				'margin-top': '',
				'margin-left': '',
				'text-decoration': 'none'
			});
		});
	});

	$('#btnThumbView').click(function() {
		$('#column-right a img').show();
		$('#column-right a img').each(function(index, e1) {
			$(e1).css({
				'width': 'auto',
				'height': 'auto',
				'float': 'none',
				'padding': '0px'
			});
		});

		$('#column-right a').each(function(index, e2) {
			$('span.fileSize').show();
			$(e2).css({
				'width': 'auto',
				'height': 'auto',
				'padding': '5px',
				'margin': '5px',
				'float': 'left',
				'text-align': 'center'
			});
			$('span.fileName').css({
				'margin-top': '',
				'margin-left': '',
				'text-decoration': 'none'
			});
		});
	});

	$('#filter').keyup(function() {
		var filter = $(this).val();

		$('#column-right a').each(function() {
			var image = $(this).text();
			var text = image.split('.');

			image = text[0];

			if (image.indexOf(filter) > -1) {
				$(this).css('display','inline-block');
			} else {
				$(this).css('display','none');
			}
		});
	});

	$('#create').bind('click', function() {
		var tree = $.tree.focused();

		if (tree.selected) {
			$('#dialog').remove();

			html = '<div id="dialog">';
			html += '<?php echo $entry_folder; ?> <input type="text" name="name" value="" /><br /><br />';
			html += '<input type="button" value="<?php echo $button_submit; ?>" />';
			html += '</div>';

			$('#column-right').prepend(html);

			$('#dialog').dialog({
				title: '<?php echo $button_folder; ?>',
				resizable: false
			});

			$('#dialog input[type=\'button\']').bind('click', function() {
				$.ajax({
					url: 'index.php?route=common/filemanager/create&token=<?php echo $token; ?>',
					type: 'post',
					data: 'directory=' + encodeURIComponent($(tree.selected).attr('directory')) + '&name=' + encodeURIComponent($('#dialog input[name=\'name\']').val()),
					dataType: 'json',
					success: function(json) {
						if (json.success) {
							$('#dialog').remove();

							tree.refresh(tree.selected);
						} else {
							alert(json.error);
						}
					},
					error: function(xhr, ajaxOptions, thrownError) {
						alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
					}
				});
			});

		} else {
			alert('<?php echo $error_directory; ?>');
		}
	});

	$('#delete').bind('click', function() {
		var path = $('#column-right a.selected').attr('file');
		var fldr = $('#column-left a.clicked').html();

		fldr = fldr.replace("<ins>&nbsp;</ins>", "");

		if (path == undefined) {
			$('#dialog').remove();

			html = '<div id="dialog">';
			html += '<p><?php echo $text_folder_action; ?>' + '<span style="font-weight:bold;"> "' + fldr + '"' + '</span><br />';
			html += '<?php echo $text_folder_content; ?><br /><br />';
			html += '<span style="font-weight:bold; color:Crimson;"><?php echo $text_confirm; ?></span></p>';
			html += '</div>';

			$('#column-right').prepend(html);

			$('#dialog').dialog({
				resizable: true,
				height: 220,
				width: 400,
				modal: true,
				title: '<?php echo $text_folder_delete; ?>',
				buttons: {
					"<?php echo $text_yes_delete; ?>": function() {
						var tree = $.tree.focused();

						if (tree.selected) {
							$.ajax({
								url: 'index.php?route=common/filemanager/delete&token=<?php echo $token; ?>',
								type: 'post',
								data: 'path=' + encodeURIComponent($(tree.selected).attr('directory')),
								dataType: 'json',
								success: function(json) {
									if (json.success) {
										var tt = tree.prev(tree.selected);

										tree.refresh(tree.parent(tree.selected));

										tree.select_branch(tt);
									}

									if (json.error) {
										alert(json.error);
									}
								},
								error: function(xhr, ajaxOptions, thrownError) {
									alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
								}
							});
						}

						$(this).dialog('close');
					},
					"<?php echo $text_no_cancel; ?>": function() {
						$(this).dialog('close');
					}
				}
			});

		} else if (path) {
			var file = path.substring(path.lastIndexOf('/') + 1).toLowerCase();

			$('#dialog').remove();

			html = '<div id="dialog">';
			html += '<p><?php echo $text_file_action; ?> ' + '<span style="font-weight:bold;"> "' + file + '"' + '</span><br /><br />';
			html += '<span style="font-weight:bold; color:Crimson;"><?php echo $text_confirm; ?></span></p>';
			html += '</div>';

			$('#column-right').prepend(html);

			$('#dialog').dialog({
				resizable: false,
				height: 220,
				width: 400,
				modal: true,
				title: '<?php echo $text_file_delete; ?>',
				buttons: {
					"<?php echo $text_yes_delete; ?>": function() {
						var tree = $.tree.focused();

						$.ajax({
							url: 'index.php?route=common/filemanager/delete&token=<?php echo $token; ?>',
							type: 'post',
							data: 'path=' + path,
							dataType: 'json',
							success: function(json) {
								if (json.success) {
									var tree = $.tree.focused();

									tree.select_branch(tree.selected);
								}

								if (json.error) {
									alert(json.error);
								}
							},
							error: function(xhr, ajaxOptions, thrownError) {
								alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
							}
						});

						$(this).dialog('close');
					},
					"<?php echo $text_no_cancel; ?>": function() {
						$(this).dialog('close');
					}
				}
			});
		}
	});

	$('#move').bind('click', function() {
		$('#dialog').remove();

		html = '<div id="dialog">';
		html += '<?php echo $entry_move; ?> <select name="to"></select><br /><br />';
		html += '<input type="button" value="<?php echo $button_submit; ?>" />';
		html += '</div>';

		$('#column-right').prepend(html);

		$('#dialog').dialog({
			title: '<?php echo $button_move; ?>',
			resizable: false
		});

		$('#dialog select[name=\'to\']').load('index.php?route=common/filemanager/folders&token=<?php echo $token; ?>');

		$('#dialog input[type=\'button\']').bind('click', function() {
			path = $('#column-right a.selected').find('input[name=\'image\']').attr('value');

			if (path) {
				$.ajax({
					url: 'index.php?route=common/filemanager/move&token=<?php echo $token; ?>',
					type: 'post',
					data: 'from=' + encodeURIComponent(path) + '&to=' + encodeURIComponent($('#dialog select[name=\'to\']').val()),
					dataType: 'json',
					success: function(json) {
						if (json.success) {
							$('#dialog').remove();

							var tree = $.tree.focused();

							tree.select_branch(tree.selected);
						}

						if (json.error) {
							alert(json.error);
						}
					},
					error: function(xhr, ajaxOptions, thrownError) {
						alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
					}
				});

			} else {
				var tree = $.tree.focused();

				$.ajax({
					url: 'index.php?route=common/filemanager/move&token=<?php echo $token; ?>',
					type: 'post',
					data: 'from=' + encodeURIComponent($(tree.selected).attr('directory')) + '&to=' + encodeURIComponent($('#dialog select[name=\'to\']').val()),
					dataType: 'json',
					success: function(json) {
						if (json.success) {
							$('#dialog').remove();

							tree.select_branch('#top');

							tree.refresh(tree.selected);
						}

						if (json.error) {
							alert(json.error);
						}
					},
					error: function(xhr, ajaxOptions, thrownError) {
						alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
					}
				});
			}
		});
	});

	$('#copy').bind('click', function() {
		$('#dialog').remove();

		html = '<div id="dialog">';
		html += '<?php echo $entry_copy; ?> <input type="text" name="name" value="" /><br /><br />'; 
		html += '<input type="button" value="<?php echo $button_submit; ?>" />';
		html += '</div>';

		$('#column-right').prepend(html);

		$('#dialog').dialog({
			title: '<?php echo $button_copy; ?>',
			resizable: false
		});

		$('#dialog select[name=\'to\']').load('index.php?route=common/filemanager/folders&token=<?php echo $token; ?>');

		$('#dialog input[type=\'button\']').bind('click', function() {
			path = $('#column-right a.selected').find('input[name=\'image\']').attr('value');

			if (path) {
				$.ajax({
					url: 'index.php?route=common/filemanager/copy&token=<?php echo $token; ?>',
					type: 'post',
					data: 'path=' + encodeURIComponent(path) + '&name=' + encodeURIComponent($('#dialog input[name=\'name\']').val()),
					dataType: 'json',
					success: function(json) {
						if (json.success) {
							$('#dialog').remove();

							var tree = $.tree.focused();

							tree.select_branch(tree.selected);
						}

						if (json.error) {
							alert(json.error);
						}
					},
					error: function(xhr, ajaxOptions, thrownError) {
						alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
					}
				});

			} else {
				var tree = $.tree.focused();

				$.ajax({
					url: 'index.php?route=common/filemanager/copy&token=<?php echo $token; ?>',
					type: 'post',
					data: 'path=' + encodeURIComponent($(tree.selected).attr('directory')) + '&name=' + encodeURIComponent($('#dialog input[name=\'name\']').val()),
					dataType: 'json',
					success: function(json) {
						if (json.success) {
							$('#dialog').remove();

							tree.select_branch(tree.parent(tree.selected));

							tree.refresh(tree.selected);
						}

						if (json.error) {
							alert(json.error);
						}
					},
					error: function(xhr, ajaxOptions, thrownError) {
						alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
					}
				});
			}
		});
	});

	$('#rename').bind('click', function() {
		$('#dialog').remove();

		html = '<div id="dialog">';
		html += '<?php echo $entry_rename; ?> <input type="text" name="name" value="" /><br /><br />';
		html += '<input type="button" value="<?php echo $button_submit; ?>" />';
		html += '</div>';

		$('#column-right').prepend(html);

		$('#dialog').dialog({
			title: '<?php echo $button_rename; ?>',
			resizable: false
		});

		$('#dialog input[type=\'button\']').bind('click', function() {
			path = $('#column-right a.selected').find('input[name=\'image\']').attr('value');

			if (path) {
				$.ajax({
					url: 'index.php?route=common/filemanager/rename&token=<?php echo $token; ?>',
					type: 'post',
					data: 'path=' + encodeURIComponent(path) + '&name=' + encodeURIComponent($('#dialog input[name=\'name\']').val()),
					dataType: 'json',
					success: function(json) {
						if (json.success) {
							$('#dialog').remove();

							var tree = $.tree.focused();

							tree.select_branch(tree.selected);
						}

						if (json.error) {
							alert(json.error);
						}
					},
					error: function(xhr, ajaxOptions, thrownError) {
						alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
					}
				});

			} else {
				var tree = $.tree.focused();

				$.ajax({
					url: 'index.php?route=common/filemanager/rename&token=<?php echo $token; ?>',
					type: 'post',
					data: 'path=' + encodeURIComponent($(tree.selected).attr('directory')) + '&name=' + encodeURIComponent($('#dialog input[name=\'name\']').val()),
					dataType: 'json',
					success: function(json) {
						if (json.success) {
							$('#dialog').remove();

							tree.select_branch(tree.parent(tree.selected));

							tree.refresh(tree.selected);
						}

						if (json.error) {
							alert(json.error);
						}
					},
					error: function(xhr, ajaxOptions, thrownError) {
						alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
					}
				});
			}
		});
	});

	new AjaxUpload('#upload', {
		action: 'index.php?route=common/filemanager/upload&token=<?php echo $token; ?>',
		name: 'image',
		autoSubmit: false,
		responseType: 'json',
		onChange: function(file, extension) {
			var tree = $.tree.focused();

			if (tree.selected) {
				this.setData({'directory': $(tree.selected).attr('directory')});
			} else {
				this.setData({'directory': ''});
			}

			this.submit();
		},
		onSubmit: function(file, extension) { },
		onComplete: function(file, json) {
			if (json.success) {
				var tree = $.tree.focused();

				tree.select_branch(tree.selected);

				alert(json.success);
			}

			if (json.error) {
				alert(json.error);
			}

			$('.loading').remove();
		}
	});

	$('#uploadmulti').click(function() {
		html = '<div id="uploadMulti" title="<?php echo $text_upload_plus; ?>">';
		html += '<div id="uploader"></div>';
		html += '</div>';

		$('#column-left').prepend(html);

		$('#uploadMulti').dialog({
			height: '355',
			width: '760',
			modal: true,
			resizable: false,
			create: function(event, ui) {
				var tree = $.tree.focused();

				$('#uploader').plupload({
					runtimes: 'html5,flash,silverlight',
					url: 'index.php?route=common/filemanager/multi&token=<?php echo $token; ?>&directory=' + window.dr,
					max_file_count: 50,
					max_file_size: '25mb',
					chunk_size: '1mb',
					unique_names: false,
					resize: { quality: 100, crop: false },
					filters: [ { title: "<?php echo $text_allowed; ?>", extensions: "jpg,jpeg,gif,png,zip,rar,pdf,flv,swf" } ],
					flash_swf_url: 'view/javascript/plupload/js/Moxie.swf',
					silverlight_xap_url: 'view/javascript/plupload/js/Moxie.xap'
				});

				$('form').submit(function(e) {
					var uploader = $('#uploader').plupload('getUploader');
					var tree = $.tree.focused('#column-left a');

					if (uploader.files.length > 0) {
						uploader.bind('StateChanged', function() {
							if (uploader.files.length === (uploader.total.uploaded + uploader.total.failed)) {
								$('form')[0].submit();
							}
						});

						uploader.start();
					} else {
						alert('<?php echo $text_no_selection; ?>');

						return false;
					}
				});
			},

			close: function(event, ui) {
				var tree = $.tree.focused();

				tree.select_branch(tree.selected);

				$('#uploadMulti').remove();
			}
		});
	});

	$('#refresh').bind('click', function() {
		var tree = $.tree.focused();

		tree.select_branch(tree.selected);
	});
});
//--></script>
</body>
</html>