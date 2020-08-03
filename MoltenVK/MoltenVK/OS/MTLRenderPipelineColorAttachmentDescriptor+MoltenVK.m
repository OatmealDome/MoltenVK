/*
 * MTLRenderPipelineDescriptor+MoltenVK.m
 *
 * Copyright (c) 2014-2018 The Brenwill Workshop Ltd. (http://www.brenwill.com)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


#include "MTLRenderPipelineDescriptor+MoltenVK.h"
#include "MVKCommonEnvironment.h"

typedef NSUInteger MTLLogicOperation;
// This is disgusting. We shouldn't have to do this. We can't even rely on this.
typedef struct MTLRenderPipelineAttachmentDescriptorPrivate {
	union {
		struct {
			BOOL blendingEnabled : 1;
			MTLBlendOperation rgbBlendOperation : 3;
			MTLBlendOperation alphaBlendOperation : 3;
			MTLBlendFactor sourceRGBBlendFactor : 5;
			MTLBlendFactor sourceAlphaBlendFactor : 5;
			MTLBlendFactor destinationRGBBlendFactor : 5;
			MTLBlendFactor destinationAlphaBlendFactor : 5;
			MTLColorWriteMask writeMask : 4;
			BOOL logicOpEnabled : 1;
			MTLLogicOperation logicOp : 4;
			MTLPixelFormat pixelFormat : 28;
		};
		struct {
			uint64_t bits;
		};
	};
} MTLRenderPipelineAttachmentDescriptorPrivate;

@interface MTLRenderPipelineColorAttachmentDescriptor ()

- (MTLRenderPipelineAttachmentDescriptorPrivate*)_descriptorPrivate;
- (BOOL)isLogicOpEnabled;
- (void)setLogicOpEnabled: (BOOL)enable;
- (MTLLogicOperation)logicOp;
- (void)setLogicOp: (MTLLogicOperation)op;

@end

@implementation MTLRenderPipelineColorAttachmentDescriptor (MoltenVK)

- (BOOL)isLogicOpEnabledMVK {
	if ([self respondsToSelector:@selector(isLogicOpEnabled)]) {
		return [self isLogicOpEnabled];
	}
	if (![self respondsToSelector:@selector(_descriptorPrivate)]) {
		return NO;
	}
	return [self _descriptorPrivate]->logicOpEnabled;
}

- (void)setLogicOpEnabledMVK: (BOOL)enable {
	if ([self respondsToSelector:@selector(setLogicOpEnabled:)]) {
		[self setLogicOpEnabled: enable];
	} else if ([self respondsToSelector:@selector(_descriptorPrivate)]) {
		[self _descriptorPrivate]->logicOpEnabled = enable;
	}
}

- (NSUInteger)logicOpMVK {
	if ([self respondsToSelector:@selector(logicOp)]) {
		return [self logicOp];
	}
	if (![self respondsToSelector:@selector(_descriptorPrivate)]) {
		return 3 /* MTLLogicOperationCopy */;
	}
	return [self _descriptorPrivate]->logicOp;
}

- (void)setLogicOpMVK: (NSUInteger)op {
	if ([self respondsToSelector:@selector(setLogicOp:)]) {
		[self setLogicOp: (MTLLogicOperation)op];
	} else if ([self respondsToSelector:@selector(_descriptorPrivate)]) {
		[self _descriptorPrivate]->logicOp = (MTLLogicOperation)op;
	}
}

@end
